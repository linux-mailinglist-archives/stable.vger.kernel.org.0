Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AC16B7DBF
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 17:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjCMQhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 12:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjCMQgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 12:36:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7507D6F633
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 09:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678725275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=fqsCCadEeLBQPiW77d6JKg08JqzcL/IQAFHTmyw+CH8=;
        b=KUV8zEZ6VcW8vQw4QRh0EpunUURdG8ICOnc9buLD82t5LkgQw3glqs6xa7rU2CjQK4F0Kh
        Z7FWNeNyiNM27DJyh4oi962IotK9AYJwgBMGUUugD9I0Lm6TbG7mM9LxOJfW1hGH/eW1Z2
        vvqK+qUYvxKpGqMJNjyb53W2x+6w6zY=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-qlVQveMXPEaRxYhND3mEEQ-1; Mon, 13 Mar 2023 12:34:34 -0400
X-MC-Unique: qlVQveMXPEaRxYhND3mEEQ-1
Received: by mail-yb1-f199.google.com with SMTP id p79-20020a25d852000000b00b32573a21a3so9064115ybg.18
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 09:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678725274;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fqsCCadEeLBQPiW77d6JKg08JqzcL/IQAFHTmyw+CH8=;
        b=tHLiEpaIg/SakveL/Wihk1pVuMmIqMrkTCobW6lD0w9ADdpTvxE0jQ9nGmCxWuKVBf
         CcSbboilTH6ow36uKKz2JfmDkOaopxGMV2vDlpLfxcgjOffcih+GbUOGUMjnh0gay8Gk
         Nd56a3xGkQnJL3wscDwD1sQs4/Vnl7wmIex+yHx66it1I2KJuFkKDVajnL6dGhwKKmde
         C2pPc5QOuAG5dngcp+QE9PJKDElmfn0wdMvrmRRe/DAx8gSnUM2dOz0VtUPITHPv5haA
         nGKWQiX/Jtsjj1j1TChQso9rfkvWxbdl9aDb2d46dJp1bn7tljWwlI90rnQFQUNp91el
         WxqQ==
X-Gm-Message-State: AO0yUKXbSfTzyZKvMsAjdJp6etsFqU42juHQsjpJ6lBKefBc0aHVI+vn
        wXjfOcbCAtboiLcjy7nismOWwsa2CnQfY49ble48jpTYyy9EUVTlpDoRpPYz1g98b3ePxdNSa2K
        9kNaekLEsHGQQMIKEAwiqI/n4wk1SOjWp
X-Received: by 2002:a25:8903:0:b0:b34:54fe:bb2d with SMTP id e3-20020a258903000000b00b3454febb2dmr5505159ybl.8.1678725274064;
        Mon, 13 Mar 2023 09:34:34 -0700 (PDT)
X-Google-Smtp-Source: AK7set9rwEaavTcoTgWbXI0LbFtdbxcqqMu1e6BjZJgz9nC/+SuTmhtRuI2V1USQTycu54eNyZs4apjIbMUh3JeZ3Tc=
X-Received: by 2002:a25:8903:0:b0:b34:54fe:bb2d with SMTP id
 e3-20020a258903000000b00b3454febb2dmr5505152ybl.8.1678725273806; Mon, 13 Mar
 2023 09:34:33 -0700 (PDT)
MIME-Version: 1.0
From:   Jason Montleon <jmontleo@redhat.com>
Date:   Mon, 13 Mar 2023 12:34:23 -0400
Message-ID: <CAJD_bPKQdtaExvVEKxhQ47G-ZXDA=k+gzhMJRHLBe=mysPnuKA@mail.gmail.com>
Subject: [REGRESSION] kbl-r5514-5663-max hdmi no longer working
To:     Linux regressions mailing list <regressions@lists.linux.dev>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It looks like HDMI audio stopped working in 5.17-rc1. I ran a bisect
which points to 636110411ca726f19ef8e87b0be51bb9a4cdef06. I built
5.17.14 with it reverted and it restored HDMI output, but it doesn't
revert cleanly from 5.18 onward.

From what I can tell it looks like -ENOTSUPP is returned from
snd_soc_dai_set_stream for hdmi1 and hdmi2 now. I'm not sure if that's
expected, but I made the following change and I have working HDMI
audio now. https://gist.github.com/jmontleon/4780154c309f956d97ca9a304a00da3f

Thank you,
Jason Montleon

