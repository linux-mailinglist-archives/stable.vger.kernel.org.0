Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30331E2711
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388801AbgEZQbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 12:31:08 -0400
Received: from mail.asbjorn.biz ([185.38.24.25]:42920 "EHLO mail.asbjorn.biz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388800AbgEZQbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 12:31:08 -0400
X-Greylist: delayed 840 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 May 2020 12:31:07 EDT
Received: from x201s.roaming.asbjorn.biz (space.labitat.dk [185.38.175.0])
        by mail.asbjorn.biz (Postfix) with ESMTPSA id 503311C29735;
        Tue, 26 May 2020 16:17:05 +0000 (UTC)
Received: from x201s.roaming.asbjorn.biz (localhost [127.0.0.1])
        by x201s.roaming.asbjorn.biz (Postfix) with ESMTP id 9EB26205107;
        Tue, 26 May 2020 16:17:01 +0000 (UTC)
Subject: Re: [PATCH 07/27] net: l2tp: deprecate PPPOL2TP_MSG_* in favour of
 L2TP_MSG_*
To:     Giuliano Procida <gprocida@google.com>
Cc:     greg@kroah.com, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        "Dmitry V. Levin" <ldv@altlinux.org>
References: <20200521235740.191338-1-gprocida@google.com>
 <20200521235740.191338-8-gprocida@google.com>
From:   =?UTF-8?Q?Asbj=c3=b8rn_Sloth_T=c3=b8nnesen?= <asbjorn@asbjorn.st>
Message-ID: <25373712-4390-5a7a-d3f9-97bd7f2d8a2a@asbjorn.st>
Date:   Tue, 26 May 2020 16:17:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521235740.191338-8-gprocida@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Giuliano,

On 5/21/20 11:57 PM, Giuliano Procida wrote:
> From: Asbjørn Sloth Tønnesen <asbjorn@asbjorn.st>
> 
> commit 47c3e7783be4e142b861d34b5c2e223330b05d8a upstream.
> 
> PPPOL2TP_MSG_* and L2TP_MSG_* are duplicates, and are being used
> interchangeably in the kernel, so let's standardize on L2TP_MSG_*
> internally, and keep PPPOL2TP_MSG_* defined in UAPI for compatibility.

Sorry for not reacting earlier.

Have you checked if a725eb15db80 should also be applied to 4.4 and 4.9?

https://lore.kernel.org/netdev/20170215022326.GA21493@altlinux.org/

-- 
Best regards
Asbjørn Sloth Tønnesen
