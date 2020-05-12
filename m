Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267F01CF38B
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 13:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgELLn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 07:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgELLn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 07:43:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D0B1206D3;
        Tue, 12 May 2020 11:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589283837;
        bh=XWF3Ll27gWZS4z6Wsu69QbzodJKIzcl42ldhql0OQtQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u2vuzKF48d3ShdJTqvQ3ZdSMnoRKvaq8SAQk1NIlT5ch2BQdzyxcbzWhV1u2fH17i
         gLseraLZn7/ptfyv8mAomIVZRkW9D47Si4GBaEWgxJzQ+llibXQRJmbwd8/bI0EtNY
         S9IezMwFIe68pWWFOsmaYsDrmQMJTqMkJmHda9JQ=
Date:   Tue, 12 May 2020 13:43:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Tobias Urdin <tobias.urdin@binero.com>
Subject: Re: [PATCH 4.19 STABLE v2 0/2] KVM: VMX: Fix null pointer dereference
Message-ID: <20200512114354.GA49138@kroah.com>
References: <20200512002815.2708-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512002815.2708-1-sean.j.christopherson@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 05:28:13PM -0700, Sean Christopherson wrote:
> A simple fix for a null pointer dereference in vmx_vcpu_run() with an
> ugly-but-safe prereq patch.
> 
> The even uglier ASM_CALL_CONSTRAINT is gone in v2 as I finally figured
> out why vmx_return was undefined: GCC dropped the entire asm blob because
> all outputs were deemed unused.

Both now queued up, thanks.

greg k-h
