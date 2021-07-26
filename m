Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF49A3D5675
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbhGZIql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232838AbhGZIqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:46:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B823C60F02;
        Mon, 26 Jul 2021 09:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627291629;
        bh=1LeqVF4F681dbtfRP6bUwk3xRJtz3PsEmbKw2qw10gM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CvQwelviEl2XYyA+QVqMohc0Keagu3p0ekmB+AxB7yofaoUUQiv1Sjdd0KfwAdtdG
         r3AN/2njmVQ6m+g51AqmzHxyNmcwuzDWRD7f2IxXITBu9T4DhOiJvwE7mSiXxizvbC
         tUdYiKvgu5AgiyLsC9c8NofQzyd5ZHByUQ7HLEIs=
Date:   Mon, 26 Jul 2021 11:22:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, stevensd@google.com, jannh@google.com,
        pbonzini@redhat.com, npiggin@gmail.com
Subject: Re: [PATCH 4.19 1/2] KVM: do not assume PTE is writable after
 follow_pfn
Message-ID: <YP5+uIqhS+wz/Kr8@kroah.com>
References: <20210723201134.3031383-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723201134.3031383-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 23, 2021 at 11:11:33PM +0300, Ovidiu Panait wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> commit bd2fae8da794b55bf2ac02632da3a151b10e664c upstream.
> 

Both now queued up, thanks!

greg k-h
