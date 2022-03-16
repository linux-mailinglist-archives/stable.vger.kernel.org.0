Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA794DA7D4
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 03:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbiCPCPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 22:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233032AbiCPCPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 22:15:37 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C08CD7
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 19:14:23 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w8so645667pll.10
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 19:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZNODnXI0GG8OUMC7M4+T77BVFbBOatlGPAjnKZlPl/Q=;
        b=ZOQrJMqceyEbrmy847BDz8rO1Y7ZnIUAR1UKmO8JWim/2yHYSkd0RGOQNgl3lS7djl
         VXHzgd56aZvg0VcALGspo50mU6DS8jZQiAtNJPKTPDs65isMzIvlr3oDB8MxOf6yLhY1
         GJEL2259m0OyEvh6jmyZRfa1sXptyo5neRJ6scuQlMLsqa1Libv1mQDlWXM3vBDwAsk7
         ufH8IRXZ5oN1ZxNloqIZRP67SE5vj0LU+Fwjg1CqAnhM9+gvCa1l2MWwETlQwdyUl6UN
         60eAmzY0BVbUfuHrkG7eC5SUsjUivvuHAHZXms2N+gFV2Xm9RdoSk3MH2Tpmk+ycRZfh
         7sFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZNODnXI0GG8OUMC7M4+T77BVFbBOatlGPAjnKZlPl/Q=;
        b=JLvkzGkyPBPRCsb6hYkLCiPlSj01t182QCf4I4xAgB9wxUR8EL3kHaqi1bhQqbivRP
         QOFLGCu/80u2nfH4XXCYRrM1+E/nzIH6UjPMoSPoJ2idHSXpDVmTLkUuiczohyaoefHN
         VpVasmCXooxkt6kl9m/jT5O2SHw9OT71mEoJms2JDVVvv5QUZ83iXiz52DBd4Peo/xLQ
         Bkg+esUVdSTj39ISA6GQl0HfZePCoYzwI2gGlXvwvFhVNGGBpfwB5xiO/7XmLZ9WUO6g
         zGgCUX7aLKpm5s1shF2aOV2WpQc3gyXITja/gRlQu0j7KHv/guz1VlhyQwZVvIT/CYkk
         n6tg==
X-Gm-Message-State: AOAM531sdrR0IM13qdXZuiG3FpU4egLOy1+2z8/Rb+3BSZ5LTXhRLyNi
        uSl0YHuSeqB5ZkmHmVW5ne/NDQ==
X-Google-Smtp-Source: ABdhPJyp4p2lLzdYUmpSbbIR7b7dCtVcRFuSn1KqZTrxASo7IhjJOMmDJruJHndLmJZMjfu9ufcvxg==
X-Received: by 2002:a17:90a:4749:b0:1be:ea64:4348 with SMTP id y9-20020a17090a474900b001beea644348mr7674697pjg.231.1647396862810;
        Tue, 15 Mar 2022 19:14:22 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id a23-20020aa794b7000000b004f7d633a87asm467073pfl.57.2022.03.15.19.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 19:14:22 -0700 (PDT)
Message-ID: <7c235bfa-d0c3-dd41-e8b2-746ce69fee1f@linaro.org>
Date:   Tue, 15 Mar 2022 19:14:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] ext4: check if offset+length is within a valid range in
 fallocate
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, Theodore Ts'o <tytso@mit.edu>
Cc:     kbuild-all@lists.01.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
References: <20220315191545.187366-1-tadeusz.struk@linaro.org>
 <202203160919.MtfBk5N0-lkp@intel.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <202203160919.MtfBk5N0-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/22 18:22, kernel test robot wrote:
> Hi Tadeusz,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on tytso-ext4/dev]
> [also build test ERROR on linus/master v5.17-rc8 next-20220315]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:https://github.com/0day-ci/linux/commits/Tadeusz-Struk/ext4-check-if-offset-length-is-within-a-valid-range-in-fallocate/20220316-031841
> base:https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git  dev
> config: arc-randconfig-r043-20220313 (https://download.01.org/0day-ci/archive/20220316/202203160919.MtfBk5N0-lkp@intel.com/config)
> compiler: arc-elf-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>          wgethttps://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          #https://github.com/0day-ci/linux/commit/bc1fdc20f07523e970c9dea4f0fbabbc437fb0d5
>          git remote add linux-reviewhttps://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Tadeusz-Struk/ext4-check-if-offset-length-is-within-a-valid-range-in-fallocate/20220316-031841
>          git checkout bc1fdc20f07523e970c9dea4f0fbabbc437fb0d5
>          # save the config file to linux build tree
>          mkdir build_dir
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash fs/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot<lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>     fs/ext4/inode.c: In function 'ext4_punch_hole':
>>> fs/ext4/inode.c:4002:50: error: 'struct ext4_sb_info' has no member named 's_blocksize'
>      4002 |         max_length = sbi->s_bitmap_maxbytes - sbi->s_blocksize;
>           |                                                  ^~

Thanks for report, but I've already sent v2:
https://lore.kernel.org/linux-ext4/20220315215439.269122-1-tadeusz.struk@linaro.org

-- 
Thanks,
Tadeusz
