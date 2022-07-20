Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2BB57AD39
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbiGTBi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239943AbiGTBip (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:38:45 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFFCFD30
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 18:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658280586; x=1689816586;
  h=subject:references:to:cc:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=YIMeUgJzTiJBtdtux8lsU++F1voJYtLjXC2AN72Sguo=;
  b=HIr65U45rOg7EOCo5rI4mFzqsTesBadr5G4ZgafqYCdd11hBdOXhKEFV
   YxUycnv5uH1yXN8wrnoVjs9YxB8lPCrIYmYcdfdDyotu3f3dXvPWzP7GN
   mVIRpj0GRovxkhhgFl7ESfK93etlDpE6+FyDzQS8n1jY6v1B09nB1pmeM
   Z1cjGmVz8sUeDyy+zUoZsKJdXWnAsiNYC3jyfsYCjPx6DamwObYyDWjyD
   0yXUc1+Sj1WJ2Adi288CobTqDC+u9tatTmO43q5bCjRrpVIaNcuX7cyIc
   9s+2p+L3THfjk/W+9wq20iUUjNjCb+uh0YIjRskLvG7lR6+YaGgKcoEfX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="269678302"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="269678302"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 18:29:45 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="625441194"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.255.30.167]) ([10.255.30.167])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 18:29:44 -0700
Subject: warning: stable kernel rule is not satisfied
References: <YtbnfenFOqj/H/bV@b2360eacd20f>
To:     Eric Snowberg <eric.snowberg@oracle.com>
Cc:     stable@vger.kernel.org
From:   kernel test robot <rong.a.chen@intel.com>
X-Forwarded-Message-Id: <YtbnfenFOqj/H/bV@b2360eacd20f>
Message-ID: <a2ebf59c-523c-ef71-0eda-39166a170810@intel.com>
Date:   Wed, 20 Jul 2022 09:29:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YtbnfenFOqj/H/bV@b2360eacd20f>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH] lockdown: Fix kexec lockdown bypass with ima policy
Link: 
https://lore.kernel.org/stable/20220719171647.3574253-1-eric.snowberg@oracle.com

The check is based on 
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp


