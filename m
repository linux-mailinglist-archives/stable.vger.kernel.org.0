Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3E4248E4F
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 20:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgHRS5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 14:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgHRS47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 14:56:59 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC1BC061389;
        Tue, 18 Aug 2020 11:56:59 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a79so10407967pfa.8;
        Tue, 18 Aug 2020 11:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b4NxHezh4S6olP7hH5t7UMSqF+kaqUz46c8k08zt1kk=;
        b=A7xVJ+CSwkIVM4arumHAWOe6lqbnXAVMJBZCGM3yRxBRu5muUJRbCzFmn+gOzbaZcc
         pICXFAo9mZwByJ0fITZopvCns4Nm6BPkUPwf2iH9cTwecj1/Xn7gTDwyOdWkHe79g/86
         EfPiIrMb4ESl2Exo2ghXZxnW6YKQhTiYErOjZHUS7JMjtomzYPGArYAcQnJx/HVvHanG
         aWCUCEoxOFF54opNamXBBeyqDQQa/jtjpqiUau5F9qS+83w5YeXdHAtmhctoNvE7AtEk
         YtkKYbX1q9PgOBlqSPOfkSv3kD8FLnc9zEk/uNTH8ldacd2m8NbCHpqIrhZ6v4P6HFme
         U6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=b4NxHezh4S6olP7hH5t7UMSqF+kaqUz46c8k08zt1kk=;
        b=lWczEL50o95WJK+W4MqWIRaktUvPJVBxvTFVHuuMwnAAS/fJAhTPWCZnV3Oc0zs9v9
         pXaZ8MK2B/j2tAkfBLHC7Lt8tFdHKK3JftNpV8WS6/JjpRLuLjnaFJRUp4GrsJNBVSTi
         25PADEO4SAHX6SBF0g9UkFg1iRjr/UOSsMyQ1qxYSvjDPrvCp4/9hKWNQIZhAoYehFDg
         yPO6TQ4WQCPlnaLEfMCNUxmARE1aEHtRtvK/rS/voycfTY6E9AMFcIdEfu6yjUcYVzes
         M+ZH5wDqT4K68NFSlsp9ZRIipE3YrJDnD6Kyt/+/xqTBRQqCmH81ZUM4J8ZMtyNuakuT
         Uakg==
X-Gm-Message-State: AOAM532zAF4qfhuu0PX7jhNUbqzD+Opy5erfy3jOLRfyc1QjmpJu+nsY
        itnZXmEUmWKmFrioXez2eEOfrR6cdFA=
X-Google-Smtp-Source: ABdhPJzKpr/fdbtzOHIlIeoA/tQ+20kO/4SWg4zLKFfJl61M+LRQqU/mMD214dV5De05WazcIQ55Gw==
X-Received: by 2002:aa7:8a08:: with SMTP id m8mr16478980pfa.135.1597777018649;
        Tue, 18 Aug 2020 11:56:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id go12sm616595pjb.2.2020.08.18.11.56.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Aug 2020 11:56:58 -0700 (PDT)
Date:   Tue, 18 Aug 2020 11:56:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/270] 5.4.59-rc1 review
Message-ID: <20200818185657.GB235171@roeck-us.net>
References: <20200817143755.807583758@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 05:13:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.59 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
