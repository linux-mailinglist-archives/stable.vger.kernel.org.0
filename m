Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E51221066
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 17:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgGOPIr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 15 Jul 2020 11:08:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50312 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgGOPIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 11:08:41 -0400
Received: from mail-pj1-f69.google.com ([209.85.216.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jvj1S-0003xU-Hc
        for stable@vger.kernel.org; Wed, 15 Jul 2020 15:08:38 +0000
Received: by mail-pj1-f69.google.com with SMTP id j17so2954376pjy.8
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 08:08:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PjMy4io7R2jHdSWxArusOtwgBaqFTbEYz/sY2JlYP5w=;
        b=du8pqVDHY2E4w6Xk+JTLK9iqcKLHE75wNaWH0yA1JSV1JLyt7sC/ZTSXjf7yhX/ppk
         8Rl2ejySPlc7QovPiQhfO3luK/248aM2h2R8RHBWF3IW/ysLd29Ae2YysbnI9nXTipsh
         FtpolZGPtTJGJCrLr/0hN4IarJNenuLId3teffej9fQkzrj2vQhXjtbg9Ci0es9/e7+8
         zYtQLdJhDZLVaHkpbAITfZyyIpLh89FMWf464lFIgzfcKSWDKnoBd6PiF8RmvFQB84+e
         7733AbVeK7JfvS79gh5fH8zpF8JVZM6Vdk1vNE9kAl18m1QfiOh5WvWJPkMWeZGC9q4w
         Z+Nw==
X-Gm-Message-State: AOAM532qlO3CLSM7ky9yTiZwgvOFTRcZ6MWEfnGCtXvh07j0tG8qGAo0
        XadryUQ0c0GOr25qbe2FkqUPKHOb6iECU3s9Kcrju67EividunzR0kF2aqWrMVRsgEUhyEnRE6U
        u1CM38zssyPqBzyD+m5ZZqWFGnCQSqqX1Jg==
X-Received: by 2002:a17:90a:3002:: with SMTP id g2mr108804pjb.68.1594825717173;
        Wed, 15 Jul 2020 08:08:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeaLMdNxhmgRLyUdtuuy7GErTF8uag+bSGeUBRnl/y7/ExiAOI6J/b8SmUhYYGsqLrNQjV8w==
X-Received: by 2002:a17:90a:3002:: with SMTP id g2mr108775pjb.68.1594825716853;
        Wed, 15 Jul 2020 08:08:36 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id 7sm2467724pgw.85.2020.07.15.08.08.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2020 08:08:36 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()"
 breaks NFS Kerberos on upstream stable 5.4.y
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <424D9E36-C51B-46E8-9A07-D329821F2647@oracle.com>
Date:   Wed, 15 Jul 2020 23:08:33 +0800
Cc:     matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6E0D09F1-601B-432B-81EE-9858EC1AF1DE@canonical.com>
References: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
 <424D9E36-C51B-46E8-9A07-D329821F2647@oracle.com>
To:     Chuck Lever <chuck.lever@oracle.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jul 15, 2020, at 23:02, Chuck Lever <chuck.lever@oracle.com> wrote:
> 
> 
> 
>> On Jul 15, 2020, at 10:48 AM, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
>> 
>> Hi,
>> 
>> Multiple users reported NFS causes NULL pointer dereference [1] on Ubuntu, due to commit "SUNRPC: Add "@len" parameter to gss_unwrap()" and commit "SUNRPC: Fix GSS privacy computation of auth->au_ralign".
>> 
>> The same issue happens on upstream stable 5.4.y branch.
>> The mainline kernel doesn't have this issue though.
>> 
>> Should we revert them? Or is there any missing commits need to be backported to v5.4?
>> 
>> [1] https://bugs.launchpad.net/bugs/1886277
>> 
>> Kai-Heng
> 
> 31c9590ae468 ("SUNRPC: Add "@len" parameter to gss_unwrap()") is a refactoring
> change. It shouldn't have introduced any behavior difference. But in theory,
> practice and theory should be the same...
> 
> Check if 0a8e7b7d0846 ("SUNRPC: Revert 241b1f419f0e ("SUNRPC: Remove xdr_buf_trim()")")
> is also applied to 5.4.0-40-generic.

Yes, it's included. The commit is part of upstream stable 5.4.

> 
> It would help to know if v5.5 stable is working for you. I haven't had any
> problems with it.

I'll ask users to test it out. 
Thanks for you quick reply!

Kai-Heng

> 
> 
> --
> Chuck Lever
> 
> 
> 

