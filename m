Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CDB30140F
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 09:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbhAWI7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 03:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbhAWI7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 03:59:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DCE520825;
        Sat, 23 Jan 2021 08:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611392305;
        bh=FsE8fYEWaykHIEMW3WpHDvxMIMv4mzO5r53rXIIcZzA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQvYXUzBU3q8gcF85TFyLij7mbgZtg55Yk+lsL/1+Yvx87kYWkwxSkBX/cTzlrH5P
         /7nve19ENzrtx3xEkcYpegr6ZpN1RobIf1O+WCSjBndUPVA1tI8fWGxhoZSwtNb8km
         ZnlPZy6ecbsGCnoiPtaXc1zv1HbI8BmWHQbBM5Vpwv79+gESurrJy1RBQi86yqKxki
         TIa3UDhI4Rul2AXYiqOLckY7LqqLGz3Xi0dEh6TBVniHi+EUduVtVU/75qroWj/m6x
         R0q/bDIRvtLtHaPi2n82MZwulPaldoGSuZNAXr50uUbHL48FT5iUdY/A5Ne6hbSrHU
         qNcf+IqYymhPw==
Date:   Sat, 23 Jan 2021 10:58:23 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-sgx@vger.kernel.org,
        kai.huang@intel.com, haitao.huang@intel.com,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
Message-ID: <YAvlLxCfN88Ii5qb@kernel.org>
References: <20210115014638.15037-1-jarkko@kernel.org>
 <YAhp4Jrj6hIcvgRC@google.com>
 <8d232931-3675-efea-2b53-a0c76e723bff@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d232931-3675-efea-2b53-a0c76e723bff@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 08:56:44AM -0800, Dave Hansen wrote:
> On 1/20/21 9:35 AM, Sean Christopherson wrote:
> > Why haven't you included the splat that Haitao provided?  That would go a long
> > way to helping answer Boris' question about exactly what is broken...
> 
> The bad news is that the original splat seems to be lost.
> 
> The good news is that this is hard to reproduce and *might* not occur on
> what got merged in mainline.
> 
> We're going to circle back around and make sure we have a clean
> reproduction before we try to fix this again.

Yeah, this a good opportunity to level up the QA.

/Jarkko
