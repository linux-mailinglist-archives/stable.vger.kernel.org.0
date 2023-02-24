Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C615E6A16B0
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 07:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjBXGmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 01:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXGmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 01:42:24 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E50136C9;
        Thu, 23 Feb 2023 22:42:22 -0800 (PST)
Received: from [192.168.0.185] (ip5f5aee41.dynamic.kabel-deutschland.de [95.90.238.65])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id B271B60027FE6;
        Fri, 24 Feb 2023 07:42:19 +0100 (CET)
Message-ID: <97a94478-7767-e2a9-a3da-85ae81f3ba5b@molgen.mpg.de>
Date:   Fri, 24 Feb 2023 07:42:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Timestamps from the future (was: [PATCH 5.10] md: Flush workqueue
 md_rdev_misc_wq in md_alloc())
To:     Hou Tao <houtao@huaweicloud.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-raid@vger.kernel.org,
        David Sloan <david.sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, houtao1@huawei.com
References: <20230224065209.3170104-1-houtao@huaweicloud.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230224065209.3170104-1-houtao@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Hou,


Am 24.02.23 um 07:52 schrieb Hou Tao:

[…]

Just a heads-up that the date/timestamp is from the future

     Received: from huaweicloud.com (unknown [10.175.124.27])
             by APP4 (Coremail) with SMTP id 
gCh0CgBXwLPzV_hjqVfcEA--.64482S4;
             Fri, 24 Feb 2023 14:23:49 +0800 (CST)
     […]
     Date:   Fri, 24 Feb 2023 14:52:09 +0800

Please check the time of your (development) system.


Kind regards,

Paul
