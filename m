Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1505F372AA2
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 15:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhEDNG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 09:06:57 -0400
Received: from mail-40135.protonmail.ch ([185.70.40.135]:59482 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhEDNG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 09:06:57 -0400
X-Greylist: delayed 92560 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 09:06:56 EDT
Date:   Tue, 04 May 2021 13:05:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1620133560;
        bh=GPFs/9O32B/BqeDDIAR14x9KFFaTDt5PKAiwUzwOwaQ=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=bnVBzyf9FLiBe4f1oKAvVHASkPD+ZI51LXcxtP9KrE/HPkIwGrLZY6GEto4VbP+Wu
         1sQatZLiLLNWnNdvt7+fq5Ct/CoHMBVvbfdjEqNmD9UIPZsd2X4QJ4QH8vEl35IoJG
         o9NECv19soVS7Q84Jd/2E2CgPJaOo1Ci2S9JS0R4=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <npSsinT79DB6Ze8QTkmLcuOTyVwRcy2FbOf0tDjpEHbTxKdYmLar8Br66_ypLjzZ86sIJKnSbUHeehagPR6RqxsJsKdWW_vWnXOUEhMC14g=@protonmail.com>
In-Reply-To: <YJD2uTdQonXymbn6@kroah.com>
References: <20210430141910.473289618@linuxfoundation.org> <20210430141910.521897363@linuxfoundation.org> <608CFF6A.4BC054A3@users.sourceforge.net> <YI6HFNNvzuHnv5VU@kroah.com> <bO2GF-6sC-I4NbFif7JoGUpuRpAV-rHEMwtLsKfN9SCsA0lwB1NgEV4OC7Xd5fdoq3UPcZ6-uh2VDSe1Xtovy8ti3k5vmOsiMVTdfTgl0Yw=@protonmail.com> <YJD2uTdQonXymbn6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, May 4, 2021 10:24 AM, Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
> All now queued up, thanks.

For 5.4 and 4.19 and 4.14 kernels there were 2 patches,
first patch is upstream commit 2800aadc18a64c96b051bcb7da8a7df7d505db3f,
second patch is upstream commit e7020bb068d8be50a92f48e36b236a1a1ef9282e.
First patch modifies iwlwifi/pcie/tx.c  (older models use this)
Second patch modifies iwlwifi/pcie/tx-gen2.c  (for newer models)

I see you queued only the "tx.c" patches, not the "tx-gen2.c" ones.

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

