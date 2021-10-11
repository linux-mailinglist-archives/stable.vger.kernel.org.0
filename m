Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1524291B7
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbhJKO2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237819AbhJKO2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ABEC60231;
        Mon, 11 Oct 2021 14:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633962406;
        bh=M7AHpkEcBko2+9aG2E/oY9bxVNgkTTvaKQ3BbbX61kk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WaRDQVpwOcUwTWB2+o+iO8Wcc439enOdPXVQ6dIuhYPfM4K70boNmqcDa6+ZRfQ/h
         cfNP5ARcztT+7fuNNvzTl2XmQUpwgAElO1dc4mEpfvLoGB/FHlS4BrKMHkAmDhP3lm
         ShWh+OuQ+2G1q6GAS39T45QVWDKCYrzUg5cAkjSHZPlfgyGqEEhCoMy+wMM0aQl1wQ
         TSz7K87uLrbQoTN6l4EVbHlZUvrKu65Kj2Y3G9Z0ELnEnJ1IGiKH7hJ33r5DvkHtcg
         Hc+20GaZMkcE6Z+XozyBrIlsigdamT/LAThR7P95mJsuHrLc74YAPoayQzvd7GPzuy
         qCj46+O8xS3Iw==
Date:   Mon, 11 Oct 2021 07:26:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 5.4 51/52] x86/hpet: Use another crystalball to evaluate
 HPET usability
Message-ID: <20211011072645.02d5ce1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YWREvi4n/PweejB1@kroah.com>
References: <20211011134503.715740503@linuxfoundation.org>
        <20211011134505.483011431@linuxfoundation.org>
        <20211011065931.78965dff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YWREvi4n/PweejB1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 16:05:50 +0200 Greg Kroah-Hartman wrote:
> > FWIW I've never seen any problems prior to Paul's rework of bad clock
> > detection in 5.13. Backports to 5.4 and 5.10 are not necessary.  
> 
> Given that the hardware is still just as broken in those older kernels,
> why not?

Just filling in with extra context, I did say "FWIW" ;)

I don't use 5.4 nor do I understand the consequences of bad hpet 
well enough to comment on risk vs reward here. By consequences 
of bad hpet I mean whether its going to impact anything beyond
the tsc -> hpet fallback (which doesn't impact <5.13).
