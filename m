Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB57163EBD
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 09:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgBSIRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 03:17:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgBSIRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 03:17:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B9B72464E;
        Wed, 19 Feb 2020 08:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582100241;
        bh=y/apaEyI7HCKmitqQ85c3Y3B0I3ape38WMGY/kKUNIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nPjx9akHSe5/2Yoza1H2TZrBNLkMpX+504E+1JOC6WuDP92k0m22bX9OrFDSlLAil
         4lzRUdPdSiKIveK2PimbQyUjWoVl6Qe+KY/nopAdFrDDiPTTtF3L1Whswi0LQOHzcb
         HWKTMS9T1lomNbf6NX/8MvPBhiLQiOoF80+c+AgU=
Date:   Wed, 19 Feb 2020 09:17:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Henrique Barboza <dbarboza@redhat.com>
Cc:     sbest@redhat.com, Greg Kurz <groug@kaod.org>,
        stable@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [RHEL 8.2 PATCH] KVM: PPC: Book3S HV: XIVE: Ensure VP isn't
 already in use
Message-ID: <20200219081719.GB2735658@kroah.com>
References: <20200218215424.28761-1-dbarboza@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218215424.28761-1-dbarboza@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 04:54:24PM -0500, Daniel Henrique Barboza wrote:
> From: Greg Kurz <groug@kaod.org>
> 
> Bugzilla: 804424
> Brew: 26599344
> Upstream: Yes
> Tested: sanity tests in a Power 8 host
> Conflicts: none

Yeah, another RH patch spew :(

Plaese fix your email tools...

