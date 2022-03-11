Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD914D691C
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 20:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347291AbiCKTdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 14:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351143AbiCKTdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 14:33:22 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3832E1CDDFE
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 11:32:19 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id x15so14373372wru.13
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 11:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=dP1t4e1QIX/GZfItTTg+2RNDJUNOs40UuDop163DbSI=;
        b=F8/wFBTs8O9urD0YIF6+5d6m9adqdcAyrvoSqmR9JjnHdxWHVxillmaNsT9eQAC9vo
         8eB0b5rA9Cremo5wZyl+b9F92k3TWPPOFA+a55MsAdytcfweyOyGGMuruk2CiZHolAIY
         rJ3fAAWI4lGOXSuZzvQjZtexSvcHtpRJx+FQ/A9dpvm4s4cwSAQb7cJ0fYWan/WUguE1
         XnxrxnKJM9KN6tPYV9fHUSB8txReE4cuIclKM2DYRUcUDwBSpU/FcSnH5rsC6JIHfTMI
         zsfjaH1vkdcdZ8AJlWnFmWD8VE22cuwP5GxEcLeluFcRjbBrSXpZPPi2cLq95DSF0NnH
         8qWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=dP1t4e1QIX/GZfItTTg+2RNDJUNOs40UuDop163DbSI=;
        b=bL5wRwQB8VU2WAsxqElerZwzLaivTKAfMXVYaVDjzMtpAZwYbh8//NM/gMI3xt5nbn
         P7AFs2hEKmBkHOr3l9YLOnP59cqEM97vpmEQsE3Pbp150hsl8Y8jq8AtBtPlt5rLX+Fm
         15IDIgbpdBe6q+Ssq3zjPTPUyND3fgI5Lsbtf9Tb7rLffkc7JchD2lfk0mvvBIvs/A7+
         A5vpeESBKdSa5uNxucjUxtxFo5T/j4bkQy+tLUuzPU20KvJ7fgxjQh1C1eX/E1ARvf+s
         jwUMAyDtg9SYDj8/CDbjBPfQdaGs8Ryd43AqNSZcsagzxV0K7wwdn4FOBrizKjg1BOzQ
         NwhQ==
X-Gm-Message-State: AOAM5324ODkjc8VADeE3FgBkVvF7yF1E3C4wnuP+kYifDrRmS+NrdiQ2
        fks+5eWA4+q/wWO6Bwvtd901S/t+Ki0=
X-Google-Smtp-Source: ABdhPJwLGoEwC6T6/VbAc0X8/GJYtkvwMdsxmFnd6CB4IUzBfQoZGsM0epmtzGE7Am0PnevPuAS75A==
X-Received: by 2002:a05:6000:1868:b0:203:732f:d657 with SMTP id d8-20020a056000186800b00203732fd657mr8061463wri.664.1647027137664;
        Fri, 11 Mar 2022 11:32:17 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id v124-20020a1cac82000000b0037c3d08e0e7sm11129907wme.29.2022.03.11.11.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 11:32:17 -0800 (PST)
Date:   Fri, 11 Mar 2022 19:32:15 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: request for 5.15-stable: b81e0c2372e6 ("block: drop unused includes
 in <linux/genhd.h>")
Message-ID: <YiujvyEhyf72iG/i@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

As reported before, the mips failure for 5.15-stable will need two backports.
I can see one of them in the queue, but looks like you have missed:
b81e0c2372e6 ("block: drop unused includes in <linux/genhd.h>")

Can you please add it to the queue.


--
Regards
Sudip
