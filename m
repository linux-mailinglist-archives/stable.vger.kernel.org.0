Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515B33A76F1
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 08:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhFOGPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 02:15:55 -0400
Received: from mail-0301.mail-europe.com ([188.165.51.139]:52539 "EHLO
        mail-0301.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhFOGPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 02:15:54 -0400
Date:   Tue, 15 Jun 2021 06:13:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1623737627;
        bh=famUP8ZoSshK6eenlnLRC/aecYEaPBAo5l23qJBhuXg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=nmoR0h8WjEZ/V0bdSV/jDdJ5nGhxP61m6gTsgJfGZcnPRbHxeoYplLrLiPMxfAy6q
         s3Nt0UnmCdamTuDaErkJ6pkR9vNxWFKZhLS7+7CHPW5GWv/uwNZJ11xKEACiwiDmco
         1hKz102n3zNk8BPEEkwPrKpx23rOPXrlLhMmVP5U=
To:     Greg KH <gregkh@linuxfoundation.org>
From:   Adam Edge <baronedge@protonmail.com>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Reply-To: Adam Edge <baronedge@protonmail.com>
Subject: Re: Regression after 5.7.19 causing major freezes on CPU loads
Message-ID: <GUSUkWNwTxbgBsjYfpPEreYbwdu5JGec4XqJhWkFs8UncAWLJ9MdDIUvmZ0wYDLj8dFmEGcImo_fDBWte9QaFV2Yil6W7XLHlyXENv6vqd8=@protonmail.com>
In-Reply-To: <YMhCK8x7R4TbnLAF@kroah.com>
References: <HnYKcqmY_z0ERb5qOOUauOLY1vt6nxuKHXzuKVrZ297elyqtzpsWTrjUUnlIDG7mQUYnJMfS8HkFceFMf0Fd_GLzOMghgf4btNt9YhwwZK0=@protonmail.com> <YMhCK8x7R4TbnLAF@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, June 15th, 2021 at 6:01 AM, Greg KH <gregkh@linuxfoundation.org=
> wrote:
> Can you use 'git bisect' to track down the commit that caused the
> problem?

As I have mentioned in my previous email, anytime I'm within the v5.8-rc*
range of commits, running the kernel fails to get past a certain point
at boot. init doesn't get executed, but SysRq keys work and I can reboot
from there. Has this happened before? If there is an alternate method
of getting the kernel debug logs for this (that doesn't involve a serial
connection, as I don't have the equipment for that), I'm happy to get
them for you.

Best Regards,
Adam Edge
