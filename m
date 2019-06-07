Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6622439225
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbfFGQbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:31:51 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:46923 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbfFGQbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 12:31:50 -0400
Received: by mail-pg1-f179.google.com with SMTP id v9so1415502pgr.13
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 09:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=SBF8rFOEfqUdAMI8bLN6taqxkeEcURVfDyGpKsFpnF4=;
        b=mUW/0m5CQZ+JtctX3kWVgYvoehwgLes0WHHNApwVckstEeIObg6wyz808F5ekGTV1U
         ngnTHcu9IG7qQkEUiib5bwrQz5D16x0MLMj4Kp+phx/UvoeLdFjJqTalDYKRfkT4/WaT
         RAIeKGwtmO9d4w58rxzpTgimNjAw1SnU8gfQG4i5SXNKJ+wlEAZ0onWi0dwSxTNFZZ/k
         /JU49f1vFUHm1rx7vzppHD1sszZPIQb4xYs/trAN6dY/c2i7OYtSQI3L4Jsy0oGH/dRg
         /3pz90vCJRCp5cK5t8RKk4xan2lRB4DNV1EHp2mH6sfJ6UsLQYOBaCOor+6k34EW2mMw
         fBqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=SBF8rFOEfqUdAMI8bLN6taqxkeEcURVfDyGpKsFpnF4=;
        b=kmf+nLDVPzuvAqUt9nrp4mvEdwEkDZfZGlw+ExqF5AnZiFLtc/Eol2gFnAg41qEDkn
         M4QGnrBVhYTd/lmd/qVu7Kpg5O+geUz/xMeMnfX8N2pkRzPh2An4725f7T9Q3mv6nDvr
         s3xZC/zRv8JwxjSUWBeApunfVxW3vkNxplSLrguQ1WEP3YNsDnEnHsFsy6e/NwCY8FIY
         aQwzI4Qf2ioZokaE0DhrOBendORnTOBzvVz5xhp1sjTdBsyke9K8xP501H8u5FpyZtgc
         5Bk/4/s1m5tK7v69w/jibMEj7Q44OiP/mAQpoYhBLKZOZOcZZQ7DFpkb4SKoZMf3hrxx
         Ro2A==
X-Gm-Message-State: APjAAAV94Ha53PmGMzb13xfGX+bmufSVsg/ddWnFrSu0gQempKR5R/4k
        8aCSjr+10dVM3Kv1rS5yLehn/2ag
X-Google-Smtp-Source: APXvYqxGJjamiS4+AyckheCRVBCxQZFDC/joffLI7Dv5TaPzD97ldperGqsELsX4PEtqstekcwQLTw==
X-Received: by 2002:a63:1316:: with SMTP id i22mr3797780pgl.274.1559925109948;
        Fri, 07 Jun 2019 09:31:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x21sm2866881pfn.91.2019.06.07.09.31.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 09:31:49 -0700 (PDT)
Date:   Fri, 7 Jun 2019 09:31:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: Build failures in v4.9.y.queue, v4.4.y.queue
Message-ID: <20190607163148.GA3723@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

arm:allmodconfig, arm:multi_v7_defconfig:

drivers/gpu/drm/rockchip/rockchip_drm_drv.c: In function 'rockchip_drm_platform_shutdown':
drivers/gpu/drm/rockchip/rockchip_drm_drv.c:486:3: error: implicit declaration of function 'drm_atomic_helper_shutdown'

Seen in both v4.4.y.queue and v4.9.y.queue.

Guenter
