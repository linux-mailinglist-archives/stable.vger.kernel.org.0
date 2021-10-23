Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3B44385CB
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 00:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhJWWXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Oct 2021 18:23:34 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:47193 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhJWWXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Oct 2021 18:23:33 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HcFzr5PCyz4xbG;
        Sun, 24 Oct 2021 09:21:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1635027673;
        bh=CyGPrXGC/BO/kmWOs4JBU+cAZa2HwgeWDXAjesvA/TU=;
        h=From:To:Cc:Subject:Date:From;
        b=AKYXuEhitEFVf7S4wVt8aFRIEg9IQwaJH1OXh2DoXqVg+92QCqOAx4/E6aXcs/sVd
         3eJwOHYL8LlPUH0Hag2IH0mSkD5MWwltFkMGv1aF5R06UKAY17xH0bjs+RfrQPofXi
         Lh220aFjvRiTh0YAwHRb6CTpU2MXPf6aiRhDhdhwXBDsyN3sJ4eVxgD03zuSJooBsG
         zUjd3m0cDeaQX3OOtiw5V56uojSQhlGcUCUyvVVUMoM42b45gZ2FTE0mloEETbD7rK
         TuIKgDjBjaTvjRrI49YY8KMzNWXwHMDKFjvKzcFt+V9fPPDwz8St1pHBkFuC9z7hWk
         nAPv0gJJ86Liw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Stable backport request
Date:   Sun, 24 Oct 2021 09:21:09 +1100
Message-ID: <87zgqzbcx6.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Please backport the following commit to v5.4 and v5.10:

  73287caa9210ded6066833195f4335f7f688a46b
  ("powerpc64/idle: Fix SP offsets when saving GPRs")


And please backport the following commits to v5.4, v5.10 and v5.14:

  9b4416c5095c20e110c82ae602c254099b83b72f
  ("KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()")

  cdeb5d7d890e14f3b70e8087e745c4a6a7d9f337
  ("KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest")

  496c5fe25c377ddb7815c4ce8ecfb676f051e9b6
  ("powerpc/idle: Don't corrupt back chain when going idle")


cheers
