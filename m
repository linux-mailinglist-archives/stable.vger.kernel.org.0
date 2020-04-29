Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553651BE024
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 16:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgD2OFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 10:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726974AbgD2OFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 10:05:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1ABC03C1AD;
        Wed, 29 Apr 2020 07:05:45 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l20so1053652pgb.11;
        Wed, 29 Apr 2020 07:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8J01/oDFV2PcJykhGwoHQX8vIr5XGOssUOqfsuxR9jc=;
        b=qs+napDFpFlo5xPyYTAJIrpT5IOt484xsLCyWrWn5ORKukrLK1OUKZ8xLNje+wWE5t
         VPyI1YjLoAvUaV5rqDCl6g3b8pxWtkz9pVpr49JYvoTFUqlu5L6qPVhCp2vV4CPEr7sf
         pqiNvbhLOFSYDNs5cTB32h64wHO1/U88UaVcX+L3sGAWfJKP7cCTJt830Q/S4WdxuFwK
         Bguj3aLTFReZjSwurbjd4qm3N5wWs9B2AcNPu1K6ljMjO9oJpTOaVBX+YiZ3Om1h7rdD
         osG3Fap5ss/alqzYIPb0bjOari2ZmhqX9Zub/Vs8sBrTT27qLx3bTLO+9VfHAs+9tEeZ
         DySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8J01/oDFV2PcJykhGwoHQX8vIr5XGOssUOqfsuxR9jc=;
        b=gdSmaPyPwySb44p0EvKKrLCzrpopX6StQV1ihCgjdXGCom/nv9rL0FH4VAa4vCHkgQ
         gxMaGdIrq3iYk4I/Y47NMx+CtZhcah/5fLx4gPPVT1iW28jTTG6figO/EjOpJzjTv86b
         B7BKXKoZYt1wrHqoO1B8rrP/iDvz9FFZL/ZFzn7HLuG0F49yePVUIzoQDpWj3fKIeVQw
         /gh0Jf6t7Tt9Q85QrWOu0lK5OyI5H2LLnliW8pMc1KQqJ/6HPdukFv0HY6g1kBfGGcxd
         RKXiDrm9+mDw2LfBLCrh+z51NFDJn3APJ+I7DIw1MXByVdbqrjbM7TaDER9Ct61JvGlG
         AF0A==
X-Gm-Message-State: AGi0PuZBIQ8gUt64IHgDvMZhCLHedX+uUladObo3a2I47zlgDWLT4wUT
        WkHOa/8B52RGrcq93upTTSk=
X-Google-Smtp-Source: APiQypJzNWQW+vkFFPFMz5ah4PlpvGIMURsTRNSJ2YRVDhClHefvyX0mKZEnVCPbWqwMY0qaunPsMg==
X-Received: by 2002:aa7:96cc:: with SMTP id h12mr27300216pfq.298.1588169144965;
        Wed, 29 Apr 2020 07:05:44 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a16sm1204686pff.41.2020.04.29.07.05.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Apr 2020 07:05:43 -0700 (PDT)
Date:   Wed, 29 Apr 2020 07:05:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/167] 5.6.8-rc1 review
Message-ID: <20200429140542.GC8469@roeck-us.net>
References: <20200428182225.451225420@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 28, 2020 at 08:22:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.8 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Apr 2020 18:20:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Guenter
