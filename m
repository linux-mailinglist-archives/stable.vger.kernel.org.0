Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10579E9054
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 20:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfJ2TwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 15:52:16 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42198 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfJ2TwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 15:52:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id z17so15440037qts.9
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 12:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=etY+CBhDEUwzAdor1k/bGcw3XJJ1m/Kp3y65R3dEiKM=;
        b=farqsGSisMFfToV5/jjl1jtlqaSaWVnx0Dkc1EINYpyGLuTn8XU7M1DVa63vG7qSSe
         NHF/BYHgnkG09TnrjKfQl89ViAKy8yfJSLoUmQCDVpVBYDEGM9hUd/+J1DeOist5yEtH
         wYJZqreDuTHrg4dryu3x+k+f2uXuZCoe7QOgCcP4zKLVKJb/Tgf4t043zuSCmywaFK8c
         hg65jqY8BKSkkuezxXM3W0c80Lk+t7DMbsJ6h/tc1xs9OADPs11wzPpDlFu9n+J8kipX
         GwkWbbLUmGDzkmcQI1/2GlGg3/yMuFCGlhccJhfJ0vY6EVMqbgHdPd37YCVXLk9+RCvY
         tipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=etY+CBhDEUwzAdor1k/bGcw3XJJ1m/Kp3y65R3dEiKM=;
        b=Qwnp83CetIvF7f5ltSIKlWIvs6FMrgFIhfxDe2wRRsUUXx3fYZRILNAZ0RApYlJCC2
         P6cXbdbQxoyRf88tkmwPN4Zx9VLEqz81fGkn2iJM1FVhz+nL9yh4vdCoMd0KB09x1wPl
         aYAZpbcjMYKv2TmPtSUvACOia8YPQu1fh5JuiDCjrwS+U8oNo5jV50HpbGSrhNjGB4rR
         AvVSRh9KvZ28BwBLk5AMd5DdZ5oycdIhPAMAWgnVQQFhzxiQMyv4BsuMNPHEp28UDK1J
         rS6fmBrZpV5VD3mnIWoE4ASijcAx6nJpRcIU2DPDOtWDmZnOnsVfAK5EJnrWF0EpcgMi
         0kKg==
X-Gm-Message-State: APjAAAVphlKToZcg9cNdxbkDVUT8z3BRT0M+3ljgVVc2vMxaFiVTYrAF
        PchNKB6JiIeqNGqKDLoCFGji3g==
X-Google-Smtp-Source: APXvYqxCYJgqGvmvouxwJHd0bRUeKLMfivNA75lKFRTkDA36hMn3sldqw9mK3gXzdCg1ydVYXI6u5g==
X-Received: by 2002:ad4:52c8:: with SMTP id p8mr11346512qvs.114.1572378735270;
        Tue, 29 Oct 2019 12:52:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id u11sm6973420qtg.11.2019.10.29.12.52.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Oct 2019 12:52:14 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iPXXK-0000Tg-35; Tue, 29 Oct 2019 16:52:14 -0300
Date:   Tue, 29 Oct 2019 16:52:14 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>, stable@vger.kernel.org,
        James Erwin <james.erwin@intel.com>
Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Allow for all speeds higher than gen3
Message-ID: <20191029195214.GA1802@ziepe.ca>
References: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
 <20191025195823.106825.63080.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025195823.106825.63080.stgit@awfm-01.aw.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 25, 2019 at 03:58:24PM -0400, Dennis Dalessandro wrote:
> From: James Erwin <james.erwin@intel.com>
> 
> The driver avoids the gen3 speed bump when the parent
> bus speed isn't identical to gen3, 8.0GT/s.  This is not
> compatible with gen4 and newer speeds.
> 
> Fix by relaxing the test to explicitly look for the lower
> capability speeds which inherently allows for all future speeds.

This description does not seem like stable material to me.

Jason
