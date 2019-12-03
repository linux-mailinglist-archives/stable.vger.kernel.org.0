Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BFA1104E6
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 20:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfLCTRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 14:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfLCTQ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 14:16:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F5D20803;
        Tue,  3 Dec 2019 19:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575400617;
        bh=RwkH1ulrDvXWwzr0DH2in8vnq4W1hdcqSlSTktOsmNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IzLA9b69IyyKmXf2EXkqbAryRlspPIP5VjeAoyBOihZMSOcXm+XynlTzth95G6uek
         gkaOC+z46RheKclf3vLkhThYMZ8sil0fhwSsVi2JEUqNF/HR+5ey4D3GE/CYSkevZP
         Bj/Sy0bDVEI9pv3r5OFVopvLNm17rlK9I/1wzLBo=
Date:   Tue, 3 Dec 2019 20:16:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jack Wang <jack.wang.usish@gmail.com>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
Message-ID: <20191203191655.GC2734645@kroah.com>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203119.676489279@linuxfoundation.org>
 <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
 <20191202145105.GA571975@kroah.com>
 <bccbfccd-0e96-29c3-b2ba-2b1800364b08@redhat.com>
 <CA+res+SffBsmmeEBYfoDwyLHvL8nqW+O=ZKedWCxccmQ9X6itA@mail.gmail.com>
 <828cf8b7-11ac-e707-57b6-cb598cc37f1b@redhat.com>
 <CA+res+Qo1mX_UFEqDD+sm80PZeW4bRN8VZeNudMDaQ=5-Ss=0g@mail.gmail.com>
 <1387d9b8-0e08-a22e-6dd1-4b7ea58567b3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387d9b8-0e08-a22e-6dd1-4b7ea58567b3@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 01:52:47PM +0100, Paolo Bonzini wrote:
> On 03/12/19 13:27, Jack Wang wrote:
> >>> Should we simply revert the patch, maybe also
> >>> 9fe573d539a8 ("KVM: nVMX: reset cache/shadows when switching loaded VMCS")
> >>>
> >>> Both of them are from one big patchset:
> >>> https://patchwork.kernel.org/cover/10616179/
> >>>
> >>> Revert both patches recover the regression I see on kvm-unit-tests.
> >> Greg already included the patches that the bot missed, so it's okay.
> >>
> >> Paolo
> >>
> > Sorry, I think I gave wrong information initially, it's 9fe573d539a8
> > ("KVM: nVMX: reset cache/shadows when switching loaded VMCS")
> > which caused regression.
> > 
> > Should we revert or there's following up fix we should backport?
> 
> Hmm, let's revert all four.  This one, the two follow-ups and 9fe573d539a8.

4?  I see three patches here, the 2 follow-up patches that I applied to
the queue, and the "original" backport of b7031fd40fcc ("KVM: nVMX:
reset cache/shadows when switching loaded VMCS") which showed up in the
4.14.157 and 4.19.87 kernels.

confused,

greg k-h
