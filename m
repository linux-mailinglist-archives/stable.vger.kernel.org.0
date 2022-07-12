Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC30571046
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 04:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiGLCh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 22:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiGLChZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 22:37:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415028CC9F;
        Mon, 11 Jul 2022 19:37:21 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id z1so6063602plb.1;
        Mon, 11 Jul 2022 19:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IxoTNA/zDnsySFdAYo8chOzZkaHvLP42Ut6JOgZ89yU=;
        b=C4iGv5VG2K/dDKqOMaykdf00mFnMNKz49RWIQBvaU8bCZSy8K0xMd9LSXYz3M8byWD
         UZklB8NdFtYahKUv0PnS3njEpEoHrVQClHJlSjmLuH6rogryhbJGkYS32XvDCNm3SorJ
         gn+CfXNJl4uZgmVFqaESl8usitUihOJ4DOa0Ww+NTXbSYt9DikkbRJ3S99E/RWJBK1Sx
         SjPYYdAnBu0igO7IRRpTeyE4KoYkZE+BnG1xBJ2eLbW0D7I44mi2L1diqCCF5t1irJhD
         Tj8yqSu0cY51KWbholhgtnepNjQxsquX3iMtidfnThxmwoWdeYgr9hBCAlP6T/aOJt++
         Mizw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IxoTNA/zDnsySFdAYo8chOzZkaHvLP42Ut6JOgZ89yU=;
        b=Gw7ZIK7eOa54PMxYcuPmWsByueevMNpFxhiqZk572ENrCAa7WXzK0t2Wf/yfV+16Pd
         dZjfBQBa/sHttrWgJEr3PU8sNtUl45Hlfe/1kfAOHImCK5FDB9piehS6E6t21Nobefme
         CffTBpzuyStUd0TI/5wzRCcqEzLaeE1BkAHKsstcgYytGj+qFJmYJ2Jb5aLssCxn07Tq
         V44DIpqnzVwisMPbKZEzfYnMzDkcDkluAYsqa/kNahMqMn8jg6W0fXJuCyQ30EyOWOm9
         kApq+g1rAZyV0AUMFTmFcknjLf7u4kNeyAQ+0Neohdl6pV/Fw8VmuVG5WYqH9QEckVV/
         bw6Q==
X-Gm-Message-State: AJIora8qPE0qDxQr+9uZx9ZmZJqhA7moNZwXB+p27/DWhx9pozwnH0v6
        rxBUE7i/gzKFOT011DhM7knqHbiAeTs=
X-Google-Smtp-Source: AGRyM1sQuiZ53u7ep2mQ2DwNFpxBtmf8xJJ5vh075VU2GLtcVkCW5Pj2Q3Ji83q7hngGdrADiUQF/g==
X-Received: by 2002:a17:90b:388e:b0:1f0:3d7f:e620 with SMTP id mu14-20020a17090b388e00b001f03d7fe620mr1655103pjb.31.1657593440778;
        Mon, 11 Jul 2022 19:37:20 -0700 (PDT)
Received: from sol (110-174-58-111.static.tpgi.com.au. [110.174.58.111])
        by smtp.gmail.com with ESMTPSA id j7-20020a625507000000b0052ac2e23295sm4006716pfb.44.2022.07.11.19.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 19:37:19 -0700 (PDT)
Date:   Tue, 12 Jul 2022 10:37:14 +0800
From:   Kent Gibson <warthog618@gmail.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] gpio: sim: fix the chip_name configfs item
Message-ID: <20220712023714.GA9406@sol>
References: <20220711173418.91709-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711173418.91709-1-brgl@bgdev.pl>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 07:34:18PM +0200, Bartosz Golaszewski wrote:
> The chip_name configs attribute always displays the device name of the
> first GPIO bank because the logic of the relevant function is simply
> wrong.
> 
> Fix it by correctly comparing the bank's swnode against the GPIO
> device's children.
> 

That works for me, so thanks for that.

Not totally convinced by Andy's suggestion to rename swnode to fwnode.
Variables should be named for what they represent, not their type, and
you use swnode extensively elsewhere in the module, so either change it
everywhere or not at all, and such a sweeping change is beyond the scope
this patch.

Though it may make his other suggestion to use device_match_fwnode()
read a little better.  No issue with that suggestion.

Cheers,
Kent.
