Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557C7E180B
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 12:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404525AbfJWKdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 06:33:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39230 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404332AbfJWKdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 06:33:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B84DA60D86; Wed, 23 Oct 2019 10:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571826781;
        bh=l84I2WzziNV0BD7aWEgYq1Gv5TQrtmbb7A4bQSUnGMI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DeMLwallnvKpf6EdDyfn5vw4Aer15gWMLZbEkaQkbyYohV/pWawrPiturV/uUAt8F
         le4fTpsi8ovBhGQlkl3fPZs2Z5fbiMW3EUDl4JZxe2yT4vH7YRgwUzTnsdzF0+rTxF
         ZpiCOfxa+gBWPfCxljL30PMMUYfymx6Te4htLSR0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7A0F4601EA;
        Wed, 23 Oct 2019 10:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571826779;
        bh=l84I2WzziNV0BD7aWEgYq1Gv5TQrtmbb7A4bQSUnGMI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=goafbxiGZYl6WAiJzjIzGM7OsIf48Zg+jzoDnLGTqWh5+0yqWLWfIiJHlFiocw1YX
         W8Xjf2s6IIJrdmULC0y9BNrNFG2oF+uQihDdoffAnbbZzNtj8HC0qzzZmULsEWLUvB
         eQTdhB6DFk8wXTDg/IW/Ct9sUJR+uktB/xaBvIEs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7A0F4601EA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V3] rtlwifi: rtl_pci: Fix problem of too small skb->len
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191021005658.31391-1-Larry.Finger@lwfinger.net>
References: <20191021005658.31391-1-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191023103300.B84DA60D86@smtp.codeaurora.org>
Date:   Wed, 23 Oct 2019 10:33:00 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In commit 8020919a9b99 ("mac80211: Properly handle SKB with radiotap
> only"), buffers whose length is too short cause a WARN_ON(1) to be
> executed. This change exposed a fault in rtlwifi drivers, which is fixed
> by regarding packets with skb->len <= FCS_LEN as though they are in error
> and dropping them. The test is now annotated as likely.
> 
> Cc: Stable <stable@vger.kernel.org> # v5.0+
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers.git, thanks.

b43f4a169f22 rtlwifi: rtl_pci: Fix problem of too small skb->len

-- 
https://patchwork.kernel.org/patch/11201179/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

