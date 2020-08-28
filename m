Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A18255CC7
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 16:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgH1Olc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 10:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgH1Ok1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 10:40:27 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556EFC061264
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 07:40:27 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id m23so1449536iol.8
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 07:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wfd5opE3qeqPzqazGbXiXCqwv/0FQmofGwguDWtZMPU=;
        b=Yu0xDscycSWS52scmqVPbGpa6pJvD6tCLxiu6F6MYyvelCEL+G0QBi38mZFZtroFus
         2+qLMyCsbwoTbzBRSi9QQWgdMm2iP5dzMYeMIYPDFhi2aeNBOFBnr6yTZopo6faMco/j
         ru9hm8wDS2yHXSKD+BLxhdmSG7LehHQU+kim33NH7mWX2HSqDsttzMkdEPaAmF0yPtCL
         BCKrXQ4OvUmCp24g69FfeL5Bg+As1SWtuS6IIIafr+2BJvYit8ZlUtpJbI/n7TYcaV9r
         DjcEAPrzHR9dsfaqs9nE0RKLo5nu33Q9dpUfuVjkZBZLYgZEosjgg4bzgsaFtR7j4Lvw
         pDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wfd5opE3qeqPzqazGbXiXCqwv/0FQmofGwguDWtZMPU=;
        b=WPl0gVQhQkZz7pT32Lq030pFMMowjPlgRcMea6fNffREAgxhbvr/geHaF9ppwzlrfl
         +CJSs5AOLKQQNbAlutEiW+k1KNQIu9aVa3PaHPL4nyNlHAxJFPJotvFX2jnmwBLSu0L/
         FagT1aLEBUAaRdF1ixOgPzKE2kbYlCu4TuG+ru1I76GJHJbU3jhWrGrBQYqjJYuI3LlH
         GjFEpyTgJ6B+6sTOkaA69skpVlh7new400NaLdrse2TvuXtr+heBg1zb4g9+Y7F0Jd3d
         s10t+g/Xa28d7mCTY6BU4SZ5O5fXjN24Iz90J5lGBAzIy/sP7ZP2QbHo2vHmtfR2TBF0
         DExA==
X-Gm-Message-State: AOAM533egNCw3Z7AaWl6PqfwqSqetubTHyuhiAwKfMlOV7rmuQj7sDKE
        A46pWXCsR0XVGwDF8BK5XXCL3mHErN6OtfIy
X-Google-Smtp-Source: ABdhPJwQt1RGW9bs7xvInGCCffWZtt3kVCzbCjuRimJ6QSqkpcl3nKcOdIssK3mnPKwwY7YOunTTnQ==
X-Received: by 2002:a5d:9b96:: with SMTP id r22mr1637059iom.66.1598625625881;
        Fri, 28 Aug 2020 07:40:25 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s87sm672338ili.73.2020.08.28.07.40.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 07:40:25 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: Stable inclusion request, 5.7
Message-ID: <00c75f42-f71e-2455-272d-d6efc715f299@kernel.dk>
Date:   Fri, 28 Aug 2020 08:40:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can you cherry-pick this one:

commit e697deed834de15d2322d0619d51893022c90ea2
Author: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Date:   Wed Jun 10 13:41:59 2020 +0800

    io_uring: check file O_NONBLOCK state for accept

into 5.7-stable? Thanks!

-- 
Jens Axboe

