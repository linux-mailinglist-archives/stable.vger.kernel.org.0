Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029271DF5C1
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 09:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbgEWHtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 03:49:17 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:49965 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387500AbgEWHtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 03:49:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9E9535800E8;
        Sat, 23 May 2020 03:49:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 23 May 2020 03:49:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=HYzvmvyhCdDCgy2Up0L8kyIQNh0
        GHJNZlq1iXsF1dWk=; b=naczRbjRRQYoLQwrtOlHT4O/toqGfVrcKqQ+mrDqEX1
        A3bZsj6fd7/9bZH6tHoMVzUleCUxr4qAVQU994l+tHR2H7EqOrpBQog0Lkuk09pH
        rxjGk5JLBLiA/ZXd6SVbzUNaF6OGHRltWaxoi4ayjKDvmhcnjOb6T6B79XDGD1Yp
        c4KrQb/hBB6BXI+bmjegSmZf5+d/h92AFsQkX1o4Cwy+oVMvsg99XDHEaPLPGbKN
        BcsFvHZ01RBalHLVxrCZlnFUGBjKHEuGYG1gOXm+eX4T+f/dGBA8EO4Keato214D
        QYGxK92x1rGodA+OgEGkNeOQcK9e+X6slCK851PWgig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HYzvmv
        yhCdDCgy2Up0L8kyIQNh0GHJNZlq1iXsF1dWk=; b=a1JDGcSIF60I70XD+vtvfN
        M0XoiqqFIjOLkTIBpuwuiFOVtN3A66HN8vDd8LrYNGxj8Mp6CuPPudBPLnWz19hr
        mCK+onEVk2UCfKYCGntHRrh5UZpOGuDWu+cyMKdaQCJHfzWdHmL6cqokfZeEKU5H
        0C/S4BNR0hZHbMMTSDykfxW1TGVJ6aBAWKwwDtBAW2T0r3ioUImNBWA7VkaSJTB2
        vO7RD3eHSKdn/FKiJ6MN+LOpOe9X3+u+lo/Z7OeTNzI1FzxwA+gWfe7Qr58yPWhN
        B+2PIAURvIxaxu56bG8nJo7Cp4u5eap/iO+XHl1QFfDljozyNO6YIcZXM2juw/3Q
        ==
X-ME-Sender: <xms:dtXIXkkUQwLyf7bLgRPA2mYvGdXHW2muFPf7U0Lls3RoVj5YzanFoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddugedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dtXIXj1VC4RADb62e_BokGosqZPXVmkrpX1zHvEuf7K88SPn1-N08g>
    <xmx:dtXIXipxBNnQQaoYtMTHHVIifjmYyu1_8hE7aMLU7AAZ_nuoCVHppA>
    <xmx:dtXIXglXK2j5Nw8E2d2C9xcQ-o1N4uwgFY-APhmsr9UWQsNMDsjRfA>
    <xmx:e9XIXvAhgaFwAyW2LMzLbyZzJdDDO6J7ctdmt5Np1E6vAH_sgxgFxA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9563B328005A;
        Sat, 23 May 2020 03:49:09 -0400 (EDT)
Date:   Sat, 23 May 2020 09:49:08 +0200
From:   Greg KH <greg@kroah.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, stable@vger.kernel.org,
        x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com, bigeasy@linutronix.de,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 5.4] KVM: x86: Fix pkru save/restore when guest
 CR4.PKE=0, move it to x86.c
Message-ID: <20200523074908.GA3285051@kroah.com>
References: <159016509437.3131.17229420966309596602.stgit@naples-babu.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159016509437.3131.17229420966309596602.stgit@naples-babu.amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 11:32:49AM -0500, Babu Moger wrote:
> [Backported upstream commit 37486135d3a7b03acc7755b63627a130437f066a]
> 
> Though rdpkru and wrpkru are contingent upon CR4.PKE, the PKRU
> resource isn't. It can be read with XSAVE and written with XRSTOR.
> So, if we don't set the guest PKRU value here(kvm_load_guest_xsave_state),
> the guest can read the host value.
> 
> In case of kvm_load_host_xsave_state, guest with CR4.PKE clear could
> potentially use XRSTOR to change the host PKRU value.
> 
> While at it, move pkru state save/restore to common code and the
> host_pkru field to kvm_vcpu_arch.  This will let SVM support protection keys.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Now applied, thanks.

greg k-h
