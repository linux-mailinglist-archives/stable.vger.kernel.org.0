Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6897F26055B
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 22:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgIGUEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 16:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbgIGUEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 16:04:43 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585E5C061573
        for <stable@vger.kernel.org>; Mon,  7 Sep 2020 13:04:40 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a65so15284585wme.5
        for <stable@vger.kernel.org>; Mon, 07 Sep 2020 13:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=2fnKx3TLr2Ci6egvm/aBr5BPyqdIbHMLr/GygAnqwHo=;
        b=fQSOxN88GEzz6rXl7LDyV1NifslltKH4iUOkFEfYMZF21ymY2wF18QWYOaCWttKkAC
         EDR8wnyedRuNtQbKZDrw8U1SPnbdsYvirpwsxS4SbT397lH9dFzaoosJQRf38JhT1c+T
         NZEZnbhVVWdOBv8PfvonzQ9T1aV+4rxZrNq18RVCXHZQ0+uuu8nzyWfeE+oY+57iUi0M
         88vOhOGn4BP75Tq5gc4CcJBVepiuKEnH5Cgv8nqQ7lDOHnX1ff1OD56NT3g5kGUJRGQR
         Yishp+ciBUGx1N+Pre63S2QgbCzzhoOKH9m4yTUdvLtbRpKr/dYlNDJrW3vux5HdlEwh
         qI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:content-transfer-encoding;
        bh=2fnKx3TLr2Ci6egvm/aBr5BPyqdIbHMLr/GygAnqwHo=;
        b=RpwzmwixNJmIUoacjpfwLmwhONahZ9E6EKpRA8XvbK5bb8Jn4nUZ4NFG6GxVp73rVh
         cUPmo9W6LEo2wjbLGV6BNnpqBxOQgb7L6Ih0UyFBcE5q1TcVSC7OHqOZZJcplUR5p36m
         Q4HFEngeIdZX8OLYxvG1JtOp9pKgZcs7YBlpSzxu2VEGs/WZh5hxw4j8ML5Ys7qhQPMv
         x530y2clGjlwkk0d1chREYatJqW2g8WtQqwIGwURrfPxui1TCxTlPAzwMipTVUSap1N5
         ptvEc4sJYvCAFKFPU7wqpX2LWmyXrENNNRsPUptVpSzy2ZG6fDLIooXjHc9buwGZZq13
         G5lQ==
X-Gm-Message-State: AOAM53120FrkgHHLIqhPPBhyxce+qlcEJe/VYhJOfZt3Y+XfPjRVDMag
        hmyzSIdYtj5hDS/Gmo5Wzx4=
X-Google-Smtp-Source: ABdhPJzIl36Bqkh+nrE2f/Nry2/qNg0v8Vd0YN0ErM+kNeWIZe/iDKe7asGjdcOlUIFWfesZkto6rg==
X-Received: by 2002:a05:600c:2054:: with SMTP id p20mr839383wmg.173.1599509079136;
        Mon, 07 Sep 2020 13:04:39 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id t15sm25729206wmj.15.2020.09.07.13.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 13:04:38 -0700 (PDT)
Date:   Mon, 7 Sep 2020 22:04:37 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Max Chou <max.chou@realtek.com>,
        Felix =?iso-8859-1?Q?D=F6rre?= <debian@felixdoerre.de>
Subject: Please apply commit 24b065727ceb ("Bluetooth: Return NOTIFY_DONE for
 hci_suspend_notifier") to v5.8.y
Message-ID: <20200907200437.GA908020@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Please apply the commit 24b065727ceb ("Bluetooth: Return NOTIFY_DONE
for hci_suspend_notifier") to the v5.8.y branch as well. As the commit
message says it fixes actually an issue:

> The original return is NOTIFY_STOP, but notifier_call_chain would stop
> the future call for register_pm_notifier even registered on other Kernel
> modules with the same priority which value is zero.

The commit misses a Fixes tag on 9952d90ea288 ("Bluetooth: Handle
PM_SUSPEND_PREPARE and PM_POST_SUSPEND") and so was not backported as
well.

This was affecting Felix Dörre (https://bugs.debian.org/964839#65)
with an out of tree module, but as the commit explains the issue seem
to be more general.

Thank you already,

Regards,
Salvatore
