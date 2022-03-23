Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516874E59B8
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 21:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbiCWUSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 16:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbiCWUSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 16:18:16 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA4E8C7C2
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 13:16:46 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id r64so1604711wmr.4
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 13:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=WhzBtZ0kQcOsVoRlJnR+Jj0pEo2kY4Lt9Tr9pLMIUCc=;
        b=nQ59ENhY1R3eJtS6c3PYgpvrziSm4flSU5DN6j8gG2M8eCywZ0aFYY6cyxK9937VMn
         CKvgsCzKdcJP5WNs4zccGFTPj480pfZMvf21cYipnOR/2z/1PDu5UQbkKy/xDm+8nEZK
         uO72YdFOnNsvc/dL6ikZ2jZbK6Nykn8g7QRqGilupvu3/Ni99ANklxwSosOwhqZBM/Rd
         F53VUWDhclqlqy9dNUnMJLGpJVUVx+EiyxgnqqRh4bwQyp/WOwkBdCI1gQnxA7EjtC2e
         uSrokM3o15o87mXJj0oFLpnJ06xDfdcVfg7uFLIgj0kP+lhslsTEn4eQ0WjlKn1EsuP0
         /qlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=WhzBtZ0kQcOsVoRlJnR+Jj0pEo2kY4Lt9Tr9pLMIUCc=;
        b=1ZIp00mFc4eK9ZeI2PR36xhId2yWcYzBcjjpk2nBQNAih3ISInTPHEnkUIu9wPbXou
         MBMyTwPPVjAx33lY5MInQ/1qMEhvzl9Q3UtGytgmd3kHzpeXCdWRJGxUXfPyXD4FNmSq
         0o0P7ExmqzuBUTpiNDuDIElQ2h6JeyvNzYx6D0GY/L462NDNkMNO3K0Kas8IzOBc2xah
         igkK80ckjW4QZbQhjIXaCdqdeH8bH6Sk0TEi6LeiVy/gN7Ulq1NaJERG9mcq4TBPKylA
         vlhI+3FGBqax/D4EpAzRoTVMF8O+rNFEwN6WXjMXUmIgdit+rWEMJJ3jWr/wxpNjDsoe
         WlIQ==
X-Gm-Message-State: AOAM531wer6Q+IyeBtMi1eYeUwA1o3zv7O3NK/IYKXn/GxMGTCHj3m7/
        aXszitY9Yhb4cXatm2G1U1pxSqKcaE7rBBbL
X-Google-Smtp-Source: ABdhPJzwpjz4ls/8uWz3Jlg2FaceDUMBVL1UXqsvTPCdlis88tNLmWvnU+FkB4l4nu9/fGPkdYAklA==
X-Received: by 2002:a1c:4e01:0:b0:38c:b316:e6f5 with SMTP id g1-20020a1c4e01000000b0038cb316e6f5mr11049951wmh.93.1648066604273;
        Wed, 23 Mar 2022 13:16:44 -0700 (PDT)
Received: from 168.52.45.77 (201.ip-51-68-45.eu. [51.68.45.201])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d588e000000b00204064a3800sm817009wrf.51.2022.03.23.13.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 13:16:43 -0700 (PDT)
Message-ID: <6b9b8cf4-d343-0cca-5908-d990758283b8@gmail.com>
Date:   Wed, 23 Mar 2022 21:16:42 +0100
MIME-Version: 1.0
User-Agent: nano 6.4
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>
From:   Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Subject: [PATCH] Bluetooth: btusb: Add another Realtek 8761BU (6dfbe29f)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_HELO_IP_MISMATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While this (6dfbe29f) patch is still in bluetooth-next, I think once it's merged it
should go into the stable tree. Keep in mind that I'm not the author.

I just saw the reports of people complaining, and noticed that the
Cc: stable@vger.kernel.org line was missing from the submission.

Something to keep in mind as an interested party before I forget. Users will
appreciate it if the one-liner lands sooner on distros, hopefully someone
will remember to do it. Sorry for the unorthodox/super early ping. :)

* https://patchwork.kernel.org/project/bluetooth/patch/YhpF0JdpCmRXZtrG@alf.mars/
* https://github.com/bluez/bluetooth-next/commit/6dfbe29f45fb0bde29213dbd754a79e8bfc6ecef
* https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1955351
* https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1955916/comments/21
