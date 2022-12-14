Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D39964CF04
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 18:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiLNR5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 12:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLNR5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 12:57:52 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B53DDF9
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 09:57:51 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id u19so27929877ejm.8
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 09:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xEt258mAu/bCv93/OPSUif8jpZ1SgFCUMtMSdQZTi4k=;
        b=QMi3wIN31q41L8aY72XCR8vhfWb/7Y2PQLeL9fOxBauBeIZ1OzuZhOuSlv1UjTg8Dz
         WvXevKL0HfRIsbo2DgQFnM0mrr71hU97ziJhIcNyToDY2QLuAMBxcmWENwcpjGhGpW0j
         HAnbp8CtM3rEm7PiVkE4LRV5SGf/ocSlEYxKhViANaAaM/1aDTh8a/vMbxO81MSKAlxf
         umBpx+FUYLxbihJbTza+bo90EaaTnJnLjr7bV8lbCccqEoPeKGOT0ZktdSvqk77ATAyQ
         pLnZK695lxjM2PSp9v7hUUXVqNZ4p134WknVpngA2wnE5cC00aQqrhg4/eaCSCVPdQW1
         RiqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xEt258mAu/bCv93/OPSUif8jpZ1SgFCUMtMSdQZTi4k=;
        b=4yE2oLnlwu8BBPX9fKtgpY/3UXcqoPR6/96ohKJWsx8ddGIaXUNm+RVlnrvyiUvdxr
         Irc4GNDZnhVRMMohTGYpLCrICvIpG+fxbV66HJuoFC1KiYjviLoY21R5u8ZAUuijp+vZ
         ns9XSzpDO1jSWnOkpDUW7uTF+I0VeL6QsPxvYcxV9Ayuk1M6M7As9SolVbYZb/+jLMU1
         XC+gVAUfDPN9Cu3q1PJ+HWD/Okdkh7gSw/sv5pLXHgQHcIoJVI4NmGQ/L7XbkmVRWl7J
         gSBCpAwb/czrGTleazLtEH4HzzA37uAKhRLOPnGT78GUkCR4Xf7QBryI/38XUQHkHgaX
         DUQg==
X-Gm-Message-State: ANoB5pk+xLRIJG/uabFddtdXDO3AZT2U7UP0xQ5r5LLIUIgM2zkkpzID
        1UmIlkWlmmvXegQ8dwe7+ajlAtkZdgIifSWsV1VhhuOJP0k=
X-Google-Smtp-Source: AA0mqf7nnfjd5bWxSePDT5kwPjgu+bqgTH0d7tSGyt89BXXLs95tp8h8nRG7ax5+Fzp+LCLHREWwvZBUF4CgrlHIo3U=
X-Received: by 2002:a17:906:4cc1:b0:7ae:50c6:fd0a with SMTP id
 q1-20020a1709064cc100b007ae50c6fd0amr46757634ejt.184.1671040669502; Wed, 14
 Dec 2022 09:57:49 -0800 (PST)
MIME-Version: 1.0
From:   David Michael <fedora.dm0@gmail.com>
Date:   Wed, 14 Dec 2022 12:57:38 -0500
Message-ID: <CAEvUa7mihsBoPhsgu0xLGWcB4N2+4CuJpycFmLm-qmqvvyUK3w@mail.gmail.com>
Subject: Patch dfd0afb ("libbpf: Fix uninitialized warning in
 btf_dump_dump_type_data") for 6.1
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

The following simple patch was merged into the upstream tree to fix a
build failure.  Can it be considered for the 6.0 and 6.1 branches?

https://github.com/torvalds/linux/commit/dfd0afbf151d85411b371e841f62b81ee5d1ca54

Thanks.

David
