Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BC852D3E1
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 15:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbiESNYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 09:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238730AbiESNYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 09:24:49 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B3BCEB85
        for <stable@vger.kernel.org>; Thu, 19 May 2022 06:24:48 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L3r794dt1zCsrl;
        Thu, 19 May 2022 21:19:49 +0800 (CST)
Received: from dggpeml500003.china.huawei.com (7.185.36.200) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 19 May 2022 21:24:45 +0800
Received: from [10.174.177.173] (10.174.177.173) by
 dggpeml500003.china.huawei.com (7.185.36.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 19 May 2022 21:24:45 +0800
Message-ID: <72a96bcb-2957-ca41-29a4-e54b9bf93531@huawei.com>
Date:   Thu, 19 May 2022 21:24:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 5.10] Revert "drm/i915/opregion: check port number bounds
 for SWSCI display power state"
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <liwei391@huawei.com>,
        <jani.nikula@intel.com>
References: <20220517124932.2241186-1-liaoyu15@huawei.com>
 <YoY/DiESRWp4smNC@kroah.com>
From:   Yu Liao <liaoyu15@huawei.com>
In-Reply-To: <YoY/DiESRWp4smNC@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.173]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500003.china.huawei.com (7.185.36.200)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, and this issue also exists in 5.15 and 5.17.

On 2022/5/19 20:58, Greg KH wrote:
> On Tue, May 17, 2022 at 08:49:32PM +0800, Yu Liao wrote:
>> This reverts commit b84857c06ef9e72d09fadafdbb3ce9af64af954f, as it's a
>> duplicate of commit eb7bf11e8ef1 ("drm/i915/opregion: check port number
>> bounds for SWSCI display power state").
>>
>> Cc: stable@vger.kernel.org # v5.10+
>> Signed-off-by: Yu Liao <liaoyu15@huawei.com>
>> ---
>>  drivers/gpu/drm/i915/display/intel_opregion.c | 15 ---------------
>>  1 file changed, 15 deletions(-)
> 
> Someone sent this right before you did:
> 	https://lore.kernel.org/r/20220517000835.2450573-1-gthelen@google.com
> 
> I'll merge them together...
> 
> thanks,
> 
> greg k-h
> .
