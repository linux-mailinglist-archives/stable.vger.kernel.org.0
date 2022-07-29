Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9E0584C89
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 09:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbiG2H3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 03:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbiG2H3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 03:29:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05E780493
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 00:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659079742; x=1690615742;
  h=subject:references:in-reply-to:to:cc:from:message-id:
   date:mime-version:content-transfer-encoding;
  bh=DGjur7ob2G3bKGxLkZFZ11jP6ajCK7zWMxZxuXTD9Nw=;
  b=VrPeFBbD4lvUMKyx+zpav3Z7eJQDSydFrX+m2NZBYQ1MRkQxHT8oDLSO
   /mOt4vUaTHWX8CVn44vWLJ9FpyCX2o+ZJ2/9WpPFL/Msc8Fst84+o6WbH
   fEIPwSuUWjEpmMBrr1PQorYys/ZM2VgSxbj0aVEJfsCe+kec853FcGJJl
   eGEOT5HB6QmAgyC2H0RxTiQ4Q+/XMQC3G5GEBdPyFFm5Ef4Y9OeatjYNu
   4hWEs+kUj9QrHtFVlIQVHoYh5PRcvNqBMb9njUSA5x0lBL5w+cDZXWeHN
   AR42nvTvoMee6akstKzz3at24kdnT4KBX8kCS9RKXedtHtq3pkliTa7CD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268477161"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="268477161"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 00:29:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="928646192"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.249.174.178]) ([10.249.174.178])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 00:29:01 -0700
Subject: warning: stable kernel rule is not satisfied
References: <YuOFhUb9VRGxk6jh@a446980b915c>
In-Reply-To: <YuOFhUb9VRGxk6jh@a446980b915c>
To:     Zhang Wensheng <zhangwensheng5@huawei.com>,
        Zhang Wensheng <zhangwensheng@huaweicloud.com>
Cc:     stable@vger.kernel.org
From:   kernel test robot <rong.a.chen@intel.com>
X-Forwarded-Message-Id: <YuOFhUb9VRGxk6jh@a446980b915c>
Message-ID: <2364552d-9b18-875a-484a-d54ee8b9b9ee@intel.com>
Date:   Fri, 29 Jul 2022 15:28:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 5.10] block: fix null-deref in percpu_ref_put
Link: 
https://lore.kernel.org/stable/20220729065243.1786222-1-zhangwensheng%40huaweicloud.com

The check is based on 
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



