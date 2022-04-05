Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41EF4F45D5
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiDEOgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 10:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386558AbiDEMys (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 08:54:48 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5AC140F3;
        Tue,  5 Apr 2022 04:59:01 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7616.dip0.t-ipconnect.de [93.221.118.22])
        by mail.itouring.de (Postfix) with ESMTPSA id 6DF74124EC0;
        Tue,  5 Apr 2022 13:58:57 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 209A5F01601;
        Tue,  5 Apr 2022 13:58:57 +0200 (CEST)
Subject: Re: [PATCH 5.15 000/913] 5.15.33-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Valentin Schneider <valentin.schneider@arm.com>
References: <20220405070339.801210740@linuxfoundation.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <373809f0-9fc8-8eeb-ff13-146df11b4ece@applied-asynchrony.com>
Date:   Tue, 5 Apr 2022 13:58:57 +0200
MIME-Version: 1.0
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(cc'ing Valentin)

On 2022-04-05 09:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 913 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This locks up  immediately when trying to use tracepoints, due to:
"sched-tracing-don-t-re-read-p-state-when-emitting-sc.patch" aka
"sched/tracing: Don't re-read p->state when emitting sched_switch event"

Reverting this patch makes things work again, at least for 5.15.x;
don't know about other series.

cheers
Holger
