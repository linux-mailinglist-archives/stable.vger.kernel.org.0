Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC31D6D5568
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 02:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjDDAMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 20:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjDDAMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 20:12:40 -0400
Received: from out28-81.mail.aliyun.com (out28-81.mail.aliyun.com [115.124.28.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BD93ABF;
        Mon,  3 Apr 2023 17:12:38 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1801081|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.00564708-0.000340503-0.994012;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047188;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.S6YpDZ6_1680567152;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.S6YpDZ6_1680567152)
          by smtp.aliyun-inc.com;
          Tue, 04 Apr 2023 08:12:34 +0800
Date:   Tue, 04 Apr 2023 08:12:35 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
Message-Id: <20230404081234.DC6A.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


fstests btrfs/056 triggered a panic for 6.1.23-rc1, but the panic does not
happen on 6.1.22.

the patch *1 dropped in 6.1.9-rc is added to 6.1.231-rc1 again.
*1 Subject: blk-mq: move the srcu_struct used for quiescing to the tagset

we need more patches because this issue does not happen(is fixed) in upstream.

so many new bug-fix patch depends on it,  so it is not good to just drop it.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/04/04

