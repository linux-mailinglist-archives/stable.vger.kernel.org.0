Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EAD3D5442
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 09:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhGZGtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 02:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhGZGtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 02:49:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EB1760E0C;
        Mon, 26 Jul 2021 07:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627284573;
        bh=kusX5fLuGdb9BFCiLE2HBjxax5OQ+uPBg5SKTqn7/Ao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OztN+U+DNu2vDKvfgBGn3PNyT0uI9SuaesCtmGVNZVD/ZSDJfKZfFS4cDWNIPfIBX
         ZN3eFcRqY2cLj+z7qLFEvn1N5so9n7tWRG58jnq9yh6gWvg2GnpSvXqEftnZPjEpTe
         gFwvU0qnxKqXekb50V3gt/tP4SeRwBlz3+wlIJqw=
Date:   Mon, 26 Jul 2021 09:13:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?QWxlcGjQv8+E?= 1 <alephpt1@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Crash Shell, Terminal, or TTY
Message-ID: <YP5gmWkTAGxH/e4/@kroah.com>
References: <CAHUEyWUFixkBRgRXYGxE5rX9ekh98+UEbhHM-PsYP7+Ok1PtQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHUEyWUFixkBRgRXYGxE5rX9ekh98+UEbhHM-PsYP7+Ok1PtQw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 02:04:17AM -0500, Alephпτ 1 wrote:
> I tried sending this as text with the commands in the email but it rejected
> it because of the code.
> 
> Hopefully this screenshot works

screenshots can not be seen with text email readers :(
