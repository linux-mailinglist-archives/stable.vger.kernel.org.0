Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAF82E9B05
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbhADQ1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbhADQ1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 11:27:25 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5F4C061574
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 08:26:44 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id g185so19902288wmf.3
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 08:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=pMCPZ/wKDh4u5Y3W53HZlL9JH+QO9JCmc9bHoKvzYD0=;
        b=o63Xyy8uGqXH/7Omc4qz4QbI4gXxds8wyFFWQlF/g/wNBzL8JNnXK7yueZ4AemEDLu
         /AVh/X2+J5CctU5NgvfSYrwHIHEF0WCNylmqgePzm2CJYUOwj6oD6IIw27acF+fabXrb
         Eii3IFs5gQ0tjvAuWjb2A9RbU1+u/9BVAGlubFs1NGQkLGTO6q4HgnXGwJAP9TRFDafI
         N9dJ+Sq6oF8vdVYJkQBXd7i2bRsQyxsdKkzyjnevm6HZR9ohT0I/Q+qYym+fP8zDEetP
         zHUE03Oi+Y7AlVWVQtBVXGtskSOCEdtYqAqSuXzP+BhEflvW/etCOZHh1Q5Rt9ucmpya
         Rkdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=pMCPZ/wKDh4u5Y3W53HZlL9JH+QO9JCmc9bHoKvzYD0=;
        b=uncOKR/iRhoSQfpdUfRvE9IvzJ614e5R2Ohhv3nFlO6AtEbgY7HARqOxn1gg++Y8ki
         juxnjobzlmNuX8bAQnAtRTvH+j356JFopMCea8BrFzTccNJq3BvDX+yKn5F64it5nkOb
         5Lw1JrYWj3X+qanJcIHKJCm239mNrFdezwQtbzZLdDdHC8nxfi93QAjOu/CvD5KGDbmN
         alD4dSDdc7y9fxF2ZdSv1gDwyt5oL6ANsyuJ1yX2RHxW3wdLD99FeSpOwSvviBDAQr0T
         hcwboOQ4Uz0rWXLqJPSUDaFP/zjpeMBSUTjpMWdtfZ7wm0HfEIleFb9vsPCC2wlrdfa1
         wRJg==
X-Gm-Message-State: AOAM532YMkHZClgbpmZ3oz0e2bY6SH79ZbYx/Pyi8pSiCCy0WTwL1wpE
        f/xvQba28wTWrRJSYaa3s0o=
X-Google-Smtp-Source: ABdhPJxXyaU24Y/W/mwqvH/zLnGRUUhQTZH/PeslB4NVIWU/iemIbB+jqolfyBWtbTW6TgOox2592w==
X-Received: by 2002:a1c:9e86:: with SMTP id h128mr28396360wme.171.1609777603672;
        Mon, 04 Jan 2021 08:26:43 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id 94sm100438372wrq.22.2021.01.04.08.26.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Jan 2021 08:26:43 -0800 (PST)
Date:   Mon, 4 Jan 2021 16:26:41 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org
Subject: request for 5.10-stable: a31489d2a368 ("Bluetooth: Fix attempting to
 set RPA timeout when unsupported")
Message-ID: <20210104162641.7tbu7xjjaiscrue3@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

This was not marked for stable but looks like it should be in 5.10-stable.
Please apply to your queue.


--
Regards
Sudip
