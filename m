Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0ED4EAC2E
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 13:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbiC2L0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 07:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbiC2L0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 07:26:44 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15B70198960;
        Tue, 29 Mar 2022 04:25:02 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A98A23A;
        Tue, 29 Mar 2022 04:25:01 -0700 (PDT)
Received: from [10.57.7.161] (unknown [10.57.7.161])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C3D003F66F;
        Tue, 29 Mar 2022 04:24:58 -0700 (PDT)
Message-ID: <cebde4f1-b3ec-dc46-dd17-a7162316aeb2@arm.com>
Date:   Tue, 29 Mar 2022 12:24:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] thermal: devfreq_cooling: use local ops instead of global
 ops
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Kant Fan <kant@allwinnertech.com>
Cc:     rui.zhang@intel.com, daniel.lezcano@linaro.org,
        javi.merino@kernel.org, edubezval@gmail.com, orjan.eide@arm.com,
        amitk@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        allwinner-opensource-support@allwinnertech.com,
        stable@vger.kernel.org
References: <20220325094436.101419-1-kant@allwinnertech.com>
 <YkLrZ9OkJz2R8tU6@kroah.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
In-Reply-To: <YkLrZ9OkJz2R8tU6@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/29/22 12:20, Greg KH wrote:
> On Fri, Mar 25, 2022 at 05:44:36PM +0800, Kant Fan wrote:
>> commit 7b62935828266658714f81d4e9176edad808dc70 upstream.
> 
> I do not see this commit in Linus's tree :(
> 
> confused,
> 
> greg k-h

My apologies Greg, I missed that.

We need to first get the patch [1] into upstream.
Kant would resend this patch after that happen.

[1] 
https://lore.kernel.org/linux-pm/20220325073030.91919-1-kant@allwinnertech.com/
