Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C05C6D5155
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 21:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjDCT2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 15:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjDCT2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 15:28:38 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88E010D8;
        Mon,  3 Apr 2023 12:28:36 -0700 (PDT)
Date:   Mon, 3 Apr 2023 21:28:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1680550114;
        bh=m1JjRogeDF0LtlNRm8rgt8NrwUKGnFgYGOi2xwp7qTA=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=HQ6/r6e59YEcpFaE5OlC5/sdNuhMLLXpa340peoQaAjs1Zu9p9Jil9OeEqWnd02E+
         QDUqmJCfcYbhfPRGlU+XNpblY3ubEx6DgmYPFP/2CWlPheIdmwnoEqhiAo1b+1tqee
         KQoK2J0iEXrMDSsLqqowv/95y4AjCgOYTNFOzvU3vAs1w6SgtdIqEOA6VoTorAPH7/
         zh9W/WbDaF0iTlAw42QHvIX42VLZmuaevEIM+MPOT9ovGDMfTjzNJUrz2dnMwh56SA
         zwaE6Xo82vHgl4hDw1vxikgpGMndxnJ2KN0jtASCqpBWsksmwF088AtLvd0hBwI0Ut
         oREHNn9otmbdw==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
Message-ID: <20230403192833.GA5308@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230403140415.090615502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.

Hi Greg

6.1.23-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
