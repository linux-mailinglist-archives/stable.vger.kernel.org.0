Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE646588AD
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 03:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiL2CjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 21:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiL2CjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 21:39:11 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D46C11A26
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 18:39:09 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id a16so14096465qtw.10
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 18:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V+bI/PInPRC98qFA9k5hncItDaGS8mMQXxFI1nQJIp4=;
        b=X2ynwz0q67XMuFqwnARpn+k6f6pCVwzBmSoa/JoVIJz0mpklDIwy4BQoCDO7AXr7X5
         AVaodKL6gzNg9EWKnNAsdyX7N0JXDgaFH5lXFL91nNU4XwO/ULdXCvzYdk4LejlCrSli
         8anKcO2Wc1N0IYw2RNS8d2rZHCxtYlJemvVSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V+bI/PInPRC98qFA9k5hncItDaGS8mMQXxFI1nQJIp4=;
        b=Xd/o6W7ABPMOvgC6XxCq4N57Rxi9XcfC5VUHDYN/2tu6O/ppk+k+DtgfMZ4Nx2CwOA
         zkCSMFulCMA/BJwScEgS3MPyEfoUZcoZmNdCDXe+vmI6QvTn9auXi1vjUAl1tgEpJhOw
         J9d/qszGEgaZ3zlzdCi9pgpxx4uN1K7+sBKuj0LubgtFeHP+5DlWX1ewVIBG4AB+IfvM
         vkT14/Mx7V4mU5CfZMD8aoYdGf2TOjMfTiiDZKR/e5sNnc8j+0CY5ShWS514yk4QLURw
         mi4oF4InsgIUkeaMKesvHXD/NANjsPU3MHs8amFFx1Bp0ueD258sp9k6+XuIyFI9LXyn
         wqAA==
X-Gm-Message-State: AFqh2krFTVyXeqoJRc76vwiQFqDT26Jyxag7CqX4QXTMPWeoojeFEx4f
        6d2DUu4A5lucBiCklfmKcn0UjzqdHRRS0W8X
X-Google-Smtp-Source: AMrXdXtfXEyda9itEIFjgy+iQfO5XoZd/e24ccb0xfNWsvdAR0VCxpQwY2mQqByeq5+GiAmig8uJAA==
X-Received: by 2002:ac8:4998:0:b0:3a6:ee87:20e7 with SMTP id f24-20020ac84998000000b003a6ee8720e7mr32841312qtq.68.1672281548027;
        Wed, 28 Dec 2022 18:39:08 -0800 (PST)
Received: from localhost (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id bl33-20020a05620a1aa100b006f474e6a715sm12257335qkb.131.2022.12.28.18.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 18:39:06 -0800 (PST)
Date:   Thu, 29 Dec 2022 02:39:06 +0000
From:   Joel Fernandes <joel@joelfernandes.org>
To:     stable@vger.kernel.org
Cc:     paulmck@kernel.org, rcu@vger.kernel.org
Subject: Please apply to v5.10 stable: 4d60b475f858 ("rcu: Prevent
 lockdep-RCU splats on lock acquisition/release")
Message-ID: <Y6z9ygSGmPNz5hfd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,
Please apply to v5.10 stable: 4d60b475f858 ("rcu: Prevent lockdep-RCU splats
on lock acquisition/release"). The patch made it in v5.11

Without it, I get the follow splat on TREE05 rcutorture testing:

[    1.253678] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.10.162-rc1+ #6
[    1.253678] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
[    1.253678] Call Trace:
[    1.253678]
[    1.253678] =============================
[    1.253678] WARNING: suspicious RCU usage
[    1.253678] 5.10.162-rc1+ #6 Not tainted
[    1.253678] -----------------------------
[    1.253678] kernel/kprobes.c:300 RCU-list traversed in non-reader section!!

I tested with the patch and the warning is gone.

thanks,

 - Joel

