Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76ED648DCE
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 21:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfFQTR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 15:17:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfFQTR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 15:17:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22EF32F8BD0;
        Mon, 17 Jun 2019 19:17:28 +0000 (UTC)
Received: from flask (unknown [10.43.2.199])
        by smtp.corp.redhat.com (Postfix) with SMTP id D15C27D65D;
        Mon, 17 Jun 2019 19:17:25 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Mon, 17 Jun 2019 21:17:24 +0200
Date:   Mon, 17 Jun 2019 21:17:24 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 22/43] KVM: nVMX: Don't dump VMCS if virtual APIC page
 can't be mapped
Message-ID: <20190617191724.GA26860@flask>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
 <1560445409-17363-23-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560445409-17363-23-git-send-email-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 17 Jun 2019 19:17:28 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2019-06-13 19:03+0200, Paolo Bonzini:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> ... as a malicious userspace can run a toy guest to generate invalid
> virtual-APIC page addresses in L1, i.e. flood the kernel log with error
> messages.
> 
> Fixes: 690908104e39d ("KVM: nVMX: allow tests to use bad virtual-APIC page address")
> Cc: stable@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Makes me wonder why it looks like this in kvm/queue. :)

  commit 1971a835297f9098ce5a735d38916830b8313a65
  Author:     Sean Christopherson <sean.j.christopherson@xxxxxxxxx>
  AuthorDate: Tue May 7 09:06:26 2019 -0700
  Commit:     Paolo Bonzini <pbonzini@redhat.com>
  CommitDate: Thu Jun 13 16:23:13 2019 +0200
  
      KVM: nVMX: Don't dump VMCS if virtual APIC page can't be mapped
      
      ... as a malicious userspace can run a toy guest to generate invalid
      virtual-APIC page addresses in L1, i.e. flood the kernel log with error
      messages.
      
      Fixes: 690908104e39d ("KVM: nVMX: allow tests to use bad virtual-APIC page address")
      Cc: stable@xxxxxxxxxxxxxxx
      Cc: Paolo Bonzini <pbonzini@xxxxxxxxxx>
      Signed-off-by: Sean Christopherson <sean.j.christopherson@xxxxxxxxx>
      Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
