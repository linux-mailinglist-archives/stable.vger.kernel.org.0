Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2084D39EAA9
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 02:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFHAZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 20:25:48 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:50995 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFHAZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 20:25:48 -0400
Received: by mail-pj1-f51.google.com with SMTP id g4so1382316pjk.0
        for <stable@vger.kernel.org>; Mon, 07 Jun 2021 17:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WQVsiIb0yGldORgauGbkyDetgrv4+ePUBuEC0M7WN2I=;
        b=P5++shujCdbLjDEen3y+Rj1sZRppznrFr3eiOkDr970VCbmnXi1Bx7u2cISgOnAQMz
         LBmxdTFkoM0K6Rk1M9KdFTOQWp3evkF2dsZENVvH8+Mc7wJ/g2dPqr4Ran/rhkvaOQQ+
         S/3p7Uoz6sjFuzhhZMNpmozwWtbtTxn//jxBHu7R8wtptEJdPd/Eb5HSKXCpU4N6jnsd
         7PT3NEX9J8MYMEVvNjBWiyvYKwKLrA4fKqWyQy7yvuXLHXu0mlWAO6x7sgcxyRAHg1Xp
         SHNydnUqKvlMHtDOvsl8DTmLPc4wMfm1FIDKrnNzethA58yEzwpNpQU9UZhNW9WIv/VB
         799w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WQVsiIb0yGldORgauGbkyDetgrv4+ePUBuEC0M7WN2I=;
        b=WKdDobpbJIvID8MD2LFHAPTrv4S5sB0lqOa/fnwbUlbBVr0gdD/WcQA/X/gAPF+aPU
         pjOwQLOmxwBpfZ3szrFhFC4hV+yMBxYCie1S1kkqjxbDO1Du4LPEA+IHpI2qZVfRn7RG
         HoW212nQglMuAAxQIqWh1ol3B/Ve/WAPyNp55Addg3c+WOSmevPNeTDUKTD5HMIaHFg/
         EamY7LtNj3OoMqDw7UaQchNb1OMTFFGaXCvPMBGRK/oUQBOLbCAZbppZm8+Qb+BNDw9e
         A7pa54Sz5u6Qf4XKPf4/S6s3By/OvBDfr1JmGESOphFtf3u12m+myyMd9oh/9QnhEPwZ
         skBw==
X-Gm-Message-State: AOAM5313MeQpMcxMvz2uat6ZuaOcvEq6YewOxSqEy8b5lWBxiVVpAtdK
        9B0ZG44EsfLCVox3a9oRhtJqGg==
X-Google-Smtp-Source: ABdhPJw+sdLy4W5PplNvYCiGxv6nFUGtf//TVmVaXHkAxGrQ2bj2Po471Zv13CsnM1n25Fzmw7i/Wg==
X-Received: by 2002:a17:90a:5911:: with SMTP id k17mr22626694pji.29.1623111763432;
        Mon, 07 Jun 2021 17:22:43 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id j7sm839217pjf.0.2021.06.07.17.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 17:22:42 -0700 (PDT)
Date:   Tue, 8 Jun 2021 00:22:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     gregkh@linuxfoundation.org, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: SVM: Truncate GPR value for DR and
 CR accesses in" failed to apply to 5.12-stable tree
Message-ID: <YL64TmEBjILbIXzu@google.com>
References: <162081623353164@kroah.com>
 <YL6NWAqmcVqmbe8+@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL6NWAqmcVqmbe8+@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 07, 2021, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, May 12, 2021 at 12:43:53PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.12-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backported patch.

All four backports look good, thanks!
