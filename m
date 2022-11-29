Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B02963CA69
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 22:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbiK2VPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 16:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbiK2VPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 16:15:41 -0500
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E887E2BB14
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 13:15:40 -0800 (PST)
Date:   Tue, 29 Nov 2022 21:15:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1669756537; x=1670015737;
        bh=A/bD7BQGW7EPBfwHJ/XfjqV7CBfRJ//0eYyF/GhFbSQ=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=YZasO6C8hzGe6sHcjePb7BazI6qtCosP29eidGhlYvGa9QALGFKNWWW9Ll6Sszd8b
         zoMyW+yVd/Z3iXSJ0FhJCRJQpERjKvkTZnzHiBt7V8EFJs9y+42cXfq2nG4GzYe9UE
         txmIKz3LL+Onx1V5A42W+6G8fv7hWDNsF6PcV9kV/rHRXgLK/n0mGnpzp1AKBxo2GG
         bWkaRGXHGLU5CMD+Z4s0w/XAYmUGcdUNkvBODDfXKEU0IAn29RAASA+X6OLx3ZYY8E
         xOdwxT2D/Vd2bsE/lUEy3PSyDhBLVzwLDgyzfqppLigAOAv2EEapzXHmEN838+rrVC
         EzNPsNcYTg/JQ==
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   hinxx <hinxx@protonmail.com>
Subject: sendfile(2) use with a char driver
Message-ID: <bb1-8NcxtVn8HSt49oYW5HaHrKdOa814M4_SnZAqAKxacGs9rbrHsadsdzZIDBaZ-w4Ki2H2InCY83bq0uBzOkj23YtHz3hYfqOFPKL87F0=@protonmail.com>
Feedback-ID: 7622358:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm looking to use a sendfile(2) with a Xilinx XDMA kernel driver in order =
to move data from a PCIe board with Xilinx FPGA to the network card with "z=
ero-copy".

Currently I'm getting EINVAL return status from sendfile(2) when providing =
opened XDMA device file descriptor as input fd.

The device driver provides a character device that can be mmap'ed.

There seem to be other restrictions. Can anyone provide insight on what wou=
ld be needed to make this work?

Thanks! //hinko
