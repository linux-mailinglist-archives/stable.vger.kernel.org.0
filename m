Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F74D21B6
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 09:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733052AbfJJHiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 03:38:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56049 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733083AbfJJHfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 03:35:40 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iISz2-0001VR-Uk; Thu, 10 Oct 2019 09:35:36 +0200
Date:   Thu, 10 Oct 2019 09:35:36 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.3 28/68] KVM: x86: Expose XSAVEERPTR to the
 guest
Message-ID: <20191010073536.ga2eb6ovrql53y6m@linutronix.de>
References: <20191009170547.32204-1-sashal@kernel.org>
 <20191009170547.32204-28-sashal@kernel.org>
 <05acd554-dd0a-d7cd-e17c-90627fa0ec67@redhat.com>
 <20191009214048.irolhz4rwfdiqf2e@linutronix.de>
 <7119916d-462e-8ba8-300c-c165d9df045a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7119916d-462e-8ba8-300c-c165d9df045a@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-10-10 00:50:09 [+0200], Paolo Bonzini wrote:
> > Also, taking advantage of this feature requires changes which just
> > landed in qemu's master branch.
> 
> That's not a big deal, every QEMU supports every kernel and vice versa.

That is correct. My point was that the visibility of this change on
user's side is very limited.

> Paolo

Sebastian
