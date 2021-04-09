Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C8735A76B
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 21:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhDITwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 15:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhDITwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 15:52:10 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D008C061762;
        Fri,  9 Apr 2021 12:51:57 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e12so6699766wro.11;
        Fri, 09 Apr 2021 12:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SS20cAEWlAaQg9dBPwSnBdv+rCvY+I61Ggv36SwWNX0=;
        b=PMcyR7DeVzg6/1S3T8s6NxFAToxG48/w8SQIqKP8ckz22YhVOb336wibsxe15Zc/hD
         be2lUQ4XPGbAwve50v/U/Es+A/mbeFT2q7n6Nw1BZ//lGzIKpzaKITpVVOuoCBXdtUCm
         JtgCv93oqR54BSsjpOmXX+Rg1hN2DOfGSYHljrFljJ1f4H+0Ld4/7eJChV8LaHBrbwtp
         ulzDMucoqe/VA1EeHbSRTFnVzhclR40fKehsnjWjEMtU6cAosIfwKW8xN6/l2b1H/rlV
         8PxMgkVuumhXodcGTeY5KBBO33r8XPW7g0NHHf6OzkAXZlMQT/pLTxkGypQtdEGmEE96
         gT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SS20cAEWlAaQg9dBPwSnBdv+rCvY+I61Ggv36SwWNX0=;
        b=EcnV+v4p5/DBipzbrDKLzDMvK5bBLDnZ1iPIAXJd69pT+KG+2rtmlZG0zMUCTJW3p+
         pt7qgBpK1ctCMPF0OuEQEEWMsTLGiR5TTbOcFsWf+MBw4FcZGAWktN0HiCwxuZLfcV+6
         Fvey9OjvS4yqp2ZiqMZQFVORaJrevBCsnKW74HIHzsUyqEw3nHBNl50gAFNDMo3q90bD
         ZfOR7RBOpq1ywX20QVForWr4mxEgCaatxcYQkIJ92WFz7Svd/Qeg2xCNlKZiCNNs07LG
         qPSogxgfcpcFmnAHHL4+sFUPtzmtU1kbxSqb4TAcs/r/h6yeXmTTpkRwycmHisWN05Sq
         drYQ==
X-Gm-Message-State: AOAM532SyjqfQy0Tromh/Z0uytZnJUZIBywDXO2CQVnVQysUZghtg8fq
        xwKiIwlKeYlTkDb92NGjVcVEisD1TvwLBZjO
X-Google-Smtp-Source: ABdhPJz0YWiv76Lr7yQB+caQH1qgt56Djnf8qHluO4sUrJ1NnNjSGLrBdmKUdxCWi1dI6iiyzDd7eA==
X-Received: by 2002:adf:fa12:: with SMTP id m18mr19212635wrr.61.1617997915979;
        Fri, 09 Apr 2021 12:51:55 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id h63sm5192125wmh.13.2021.04.09.12.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 12:51:55 -0700 (PDT)
Date:   Fri, 9 Apr 2021 20:51:54 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 5.10 39/41] bpf, x86: Validate computation of branch
 displacements for x86-32
Message-ID: <YHCwWhGh7eoU8OdU@debian>
References: <20210409095304.818847860@linuxfoundation.org>
 <20210409095306.075652415@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095306.075652415@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Apr 09, 2021 at 11:54:01AM +0200, Greg Kroah-Hartman wrote:
> From: Piotr Krysiuk <piotras@gmail.com>
> 
> commit 26f55a59dc65ff77cd1c4b37991e26497fc68049 upstream.

I am not finding this in Linus's tree and even not seeing this change in
master branch also. Am I missing something?


--
Regards
Sudip
