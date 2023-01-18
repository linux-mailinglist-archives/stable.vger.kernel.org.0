Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FEE6710F2
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 03:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjARCOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 21:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjARCOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 21:14:41 -0500
Received: from out20-87.mail.aliyun.com (out20-87.mail.aliyun.com [115.124.20.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA072C646;
        Tue, 17 Jan 2023 18:14:39 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1684025|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0108859-0.000814038-0.9883;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047201;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.Qvn4t1z_1674008073;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.Qvn4t1z_1674008073)
          by smtp.aliyun-inc.com;
          Wed, 18 Jan 2023 10:14:34 +0800
Date:   Wed, 18 Jan 2023 10:14:35 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hch@lst.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
In-Reply-To: <Y8Znr6CAFi8ikhdH@kroah.com>
References: <20230117151136.CB79.409509F4@e16-tech.com> <Y8Znr6CAFi8ikhdH@kroah.com>
Message-Id: <20230118101433.734D.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> On Tue, Jan 17, 2023 at 03:11:37PM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > fstests(generic/034, xfs) panic when 6.1.7-rc1, but not panic when 6.1.6.
> > 
> > It seems patch *1 related.
> > *1 Subject: blk-mq: move the srcu_struct used for quiescing to the tagset
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > This patch has been drop from 6.1.2-rc1. and it now added in 6.1.7-rc1 again.
> > 
> > the panic in 6.1.7-rc1 is almost same as that in 6.1.2-rc1.
> 
> Argh, yes, let me go drop these again.
> 
> Sasha, can you blacklist these from your tools so they don't get picked
> up again?

this panic does not happen on  upstream 6.2.0-rc4.
or maybe we need a bigger patch set?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/01/18

