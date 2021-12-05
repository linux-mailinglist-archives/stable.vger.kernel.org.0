Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55E1468ADD
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhLEMwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:52:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37406 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhLEMwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:52:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3848560F50
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4DBC341C5;
        Sun,  5 Dec 2021 12:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638708561;
        bh=+gYZ42bWiy5/+MHNXBrf0wV39RCMhtkBoGZxwOzbJ4U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p3FDgv2J6hAUR6WRGC97YDgBSnXgDuNVXzUI7gYKqp4pZOfRYjotZNUUm07QGRdza
         xHORd1/RgA4Vi0eMgvpITOEI+amcnYUxN7AsMl/YWTb7XoZwEAtj65EIoyrGCZ5khi
         wJMoVzkXSMhk7EvNa8d/yBSw4Z55+7jB3IsYGcGulXYGs47Cqn1t2HQbKIMty6mi+K
         pAd7704KdrcFdZRpjmSiWGathY9VcYvysUYiULYT4xD9rtu0SjIiDLLLcrh0TsL7TB
         oSQxlNFShL/injUXXRYBZx7MS12nN62IUcKePhiaBS7oa2IuY6z6fn7nsQjF43Xei+
         51urYlkt5nDOA==
Date:   Sun, 5 Dec 2021 13:49:16 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: Save power by
 disabling SerDes" failed to apply to 5.15-stable tree
Message-ID: <20211205134916.4fb5f8ca@thinkpad>
In-Reply-To: <YayzZex0zXvDxg2V@kroah.com>
References: <16386137159777@kroah.com>
        <20211204115719.3315663b@thinkpad>
        <YayzZex0zXvDxg2V@kroah.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 5 Dec 2021 13:41:09 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sat, Dec 04, 2021 at 11:57:19AM +0100, Marek Beh=C3=BAn wrote:
> > In fact it was a series of 6 patches, but the 2nd was without fixes tag:
> >=20
> > 21635d9203e1cf2b73b67e9a86059a62f62a3563
> > 8c3318b4874e2dee867f5ae8f6d38f78e044bf71 (without fixes tag)
> > 7527d66260ac0c603c6baca5146748061fcddbd6 (didnt apply)
> > 93fd8207bed80ce19aaf59932cbe1c03d418a37d
> > 163000dbc772c1eae9bdfe7c8fe30155db1efd74
> > ede359d8843a2779d232ed30bc36089d4b5962e4 =20
>=20
> So what am I supposed to do here?  Apply all of them?  3 of them?  None
> of them?

Sorry. All of them should be applied.

All but second have fixes tags. And second needs to be applied becaues
third depends on it.

They also should be applies in that order.

Marek
