Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251FD53CADA
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 15:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbiFCNqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 09:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244791AbiFCNqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 09:46:38 -0400
Received: from mailout.rz.uni-frankfurt.de (mailout.rz.uni-frankfurt.de [141.2.22.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE83C39B9F
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 06:46:36 -0700 (PDT)
Received: from smtpauth2.cluster.uni-frankfurt.de ([10.1.1.238])
        by mailout.rz.uni-frankfurt.de with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nx7dK-00007R-M8; Fri, 03 Jun 2022 15:46:34 +0200
Received: from p57bcf3b2.dip0.t-ipconnect.de ([87.188.243.178] helo=[192.168.2.17])
        by smtpauth2.cluster.uni-frankfurt.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nx7dK-0004S8-KY; Fri, 03 Jun 2022 15:46:34 +0200
Message-ID: <21de0fda-0ff0-a553-dae4-193eaec25ca3@med.uni-frankfurt.de>
Date:   Fri, 3 Jun 2022 15:46:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: boot loop since 5.17.6
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <YpkY0RLWki4PJ49y@kroah.com>
 <88b0eb42-41eb-af0e-285c-05f86a5c5fea@med.uni-frankfurt.de>
 <YpoFId6um9GaXKha@kroah.com>
From:   Thomas Sattler <sattler@med.uni-frankfurt.de>
In-Reply-To: <YpoFId6um9GaXKha@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 03.06.22 um 14:57 schrieb Greg KH:
> On Fri, Jun 03, 2022 at 01:29:26AM +0200, Thomas Sattler wrote:
>> Am 02.06.22 um 22:08 schrieb Greg KH:
>>> On Thu, Jun 02, 2022 at 06:14:43PM +0200, Thomas Sattler wrote:
>>
>> Now, knowing that they were two patchsets, I compiled 5.17.12
>> twice, once without 60d2b0b1018a and once without d17f64c29512.
>>
>> And it turns out it is 60d2b0b1018a which breaks my system.
> 
> Does 5.18.1 also break for you?
> 

There is no difference between 5.17.6, 5.17.12 and 5.18.1:

   - they do not boot vanilla
   - applying ead165fa1042 is no help
   - reverting 60d2b0b1018a allows booting

Thomas
