Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8BD4925E8
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 13:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbiARMoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 07:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237803AbiARMol (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 07:44:41 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94550C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 04:44:40 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JdT4Q2g5yz4y3p;
        Tue, 18 Jan 2022 23:44:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1642509878;
        bh=3HpsUpw7+GNqEHUAdgbr/9iPd9Kkotoh7+dN/nfDHxM=;
        h=From:To:Subject:Date:From;
        b=XtNIwIa8GhKooe69Db6sXARPk5LVimE4k25vgjHbZy6LgeI13KL/oJ2y5OKPvs2Uu
         hb0jGtlVPDWoZLWFhwCj2FPiUnk5PwgQ50dvYsTR+QB+awKopX3kvfyFevslQt3mIX
         yF8/MV0q8qk/F9wHnFZnjH6WLEpgomOQWveQqA4GXq6voC0KB4jOWn+eNyjF+kdN8Y
         3MBeFWJh/PRytcgSsgNecDkO/+WTfN3TfzTH/vmYmoWPOrugYXsPqJDDQWeX8gUWtg
         m612b+1KZaDdBisggUgxrnJd3E7WoN0UiJeRoRXtuZ9y8vQSwWxuLMI5TCy9cpjHl2
         8AvPmJw7BGPvA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Please backport b6b0d883bbb8 to v5.10
Date:   Tue, 18 Jan 2022 23:44:35 +1100
Message-ID: <87lezd1ado.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Could you please backport:

  b6b0d883bbb8 ("powerpc/pseries: Get entry and uaccess flush required bits from H_GET_CPU_CHARACTERISTICS")

to the v5.10 stable kernel. Thanks.

cheers
