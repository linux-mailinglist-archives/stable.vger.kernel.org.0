Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1570B30B2E3
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 23:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhBAWof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 17:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229884AbhBAWod (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 17:44:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E807C64EC6;
        Mon,  1 Feb 2021 22:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612219433;
        bh=ulanPaOvdT2jLgFJH9hnh4U8sVhNedzh7EfP4TfYsrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iAR+LmlCW8hfv7whvLJhgaP1HLxLx4PkdRL1VNLfuV6MFy+JjRUgs9jYUQdmCiEhQ
         JnOuRNz5o9/HD26DrZ1tYjBssTr5VfF7KfdrC0POtjE8Qc4PJBUBhY0LYNf5fHgsTF
         Jt5+2icy2giksA8QNH6KVh57/HYKp2qC6EZqglAtG7oJUm/kzAagm3DWjL2/aOcZ87
         oYTB5UkpdN2xEBKnCEjhmo1CrdCfmT/s2gjhiw+3ZdrYmgu7BCNZhyRbLN2M2/CcJi
         nQ5xZt56mpZfl1JltdYYhFhEw6SdQ0Fcyxz2mS7lMr6o4dwTn65nydNU2N78O+2SFj
         lDVx50BRNw9Bw==
Date:   Mon, 1 Feb 2021 14:43:51 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] random: fix the RNDRESEEDCRNG ioctl
Message-ID: <YBiEJ9Md60HjAWJg@sol.localdomain>
References: <20210112192818.69921-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112192818.69921-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 11:28:18AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The RNDRESEEDCRNG ioctl reseeds the primary_crng from itself, which
> doesn't make sense.  Reseed it from the input_pool instead.
> 
> Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
> Cc: stable@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> Andrew, please consider taking this patch since the maintainer has been
> ignoring it for 4 months
> (https://lkml.kernel.org/lkml/20200916041908.66649-1-ebiggers@kernel.org/T/#u).

Ping.
