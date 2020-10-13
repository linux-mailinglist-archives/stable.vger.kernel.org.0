Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E3D28D267
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 18:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgJMQkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 12:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbgJMQkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 12:40:36 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD22BC0613D0;
        Tue, 13 Oct 2020 09:40:34 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id i12so621026ota.5;
        Tue, 13 Oct 2020 09:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mPS1lXTI7fqWjCZAvY2/mO4phMQ7/M06Cdazy5LkQjg=;
        b=jYAScywwKlqshWVFJyyuuxG4ybMwjOt5YU46oM0zR50ESQx/4Y4oL1bxvCRIEewSUq
         MG+iSABiJoICdajHa6C3Io0plBnnSltZ1PAB/cZcMsEkPW1PEQk+qLReOZiHr8LbIIUK
         oII++bpggwGJ2IhrQuXZAl/4bONOweBC6+PVXM3gnyfnAteE79WAsIaLesRoKHM9xY1m
         ZyNgRExHMeBF8YZ6XH8s4xw0ZKiRr4RG5ERxVQOYEqcayqB17ZMbAMf414NQGR90t8hO
         WIjGuDzAogEcHHYmtn5dsgKcCWGvy2hVQjrAIDVtnBSPiWYgkQqDQNfdEoQA9VeDbXYV
         aTkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mPS1lXTI7fqWjCZAvY2/mO4phMQ7/M06Cdazy5LkQjg=;
        b=RQCdelmk61azhaQ9dIuHdPU5RjhvAwXIPREwqWBxnBuPJtKXJM0zMcMnEY5UMWFEwN
         IWWPZQ7ilxIwY4uOchxmdo7tc4p9aRAQ2m2ifZkYHRCktHHKygGDq/JjzXEb7HkUtlZv
         4bH0Z37KNLgcJWPc7Oxyv99riNr0f8uMm6942BIdAErnHpiE+Krv7vWCylpo9XufVObD
         gCMyNu9hJrzSUGjlDA3/7srEGop/EluwkG0N+3uBI5+csxcW2tgG9AXDxptLySqm2f+E
         lsZQfi9T1xEwqrNEBCHCKUCEb4P52YaZX8f8Cb+AQpRNH/XB9bgIWk66jxvXLNMRbctN
         Ttlg==
X-Gm-Message-State: AOAM531we34VTxwtpxCAMfo6GddDWgX7ge4HetdTpSG4UJOttUEl+XAx
        3ujH9BZV3OCbpfxIdzdmW1Q=
X-Google-Smtp-Source: ABdhPJxujtEVibL7MiiKuP/DMlCq4wjVAORVS3bOOJ4fK+Q4oHdRFrSXAKhyHY5asLzGXjx6MlHewA==
X-Received: by 2002:a9d:1e86:: with SMTP id n6mr398192otn.94.1602607234057;
        Tue, 13 Oct 2020 09:40:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k51sm85400otc.46.2020.10.13.09.40.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Oct 2020 09:40:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 13 Oct 2020 09:40:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/49] 4.19.151-rc1 review
Message-ID: <20201013164032.GD251780@roeck-us.net>
References: <20201012132629.469542486@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 03:26:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.151 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 153 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
