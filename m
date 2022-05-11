Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142D1523ECE
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 22:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345223AbiEKUV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 16:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238984AbiEKUV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 16:21:28 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163D6703DD
        for <stable@vger.kernel.org>; Wed, 11 May 2022 13:21:27 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id x12so2731812pgj.7
        for <stable@vger.kernel.org>; Wed, 11 May 2022 13:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=QZJxyTNwcdR6jXJ6iqWTpwb254N1hEDKTMQ0/smdJ2s=;
        b=bku7XICsIXZbA9Z6HhuU9GZmYpZKXEHyEGQkTtzeMYwQhpGuGcfL2sjLJ8zI1/Ca02
         E7buvmaZGuzcdIhvq411Ox3hlk2df2Xg3wTOz09fF3XSpHHV/0WLWFmYhcdXZcV7+mpr
         mdXJPnWQk3LSOmtMDjUaGI0ugs0SDDelDMv/VA4cQS1ZzxQE6l9sn/h9W7AY3bDLdfZV
         b9So1jL0iLs1bYKUP8zBaKnBd/BpGX+ScNcd2q3ae7++OrALQaKY/6JxzxchrLUITAgN
         0N5KBhXh7WLNbCnTOQAQ4MK/5D1f+0NUfpm0FmF+ToHBck6AOfNYykdpDGV9ARJbEwO1
         BgSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=QZJxyTNwcdR6jXJ6iqWTpwb254N1hEDKTMQ0/smdJ2s=;
        b=qESujeg/l7L92QZiV37ef1uvGil3fmX87KqFPV1G8v3MBhkFhdCOYxRc+pIeD5BtVQ
         opLK7EIk0q07ZcpqgrAuCxxmt3m51+UW56C0K4JEsqU96cfIPH8kxVZ4FAkTH97r5Gpy
         6FKtT1QbS9bV/NsCUwCAQFAK4XYwD2+uojDMlcJu2AeuN3NljzRMhL0ntBFhjAo+B3xA
         ZXRDNqpOfZ7lMytClL3HhfQgtN+XGLYfxNv2cPthBZ6YS7EmhGII9uo40bU9F6WwICQk
         +j61icZneXJ7rAMbFUSzyl1t5xVDfK8rup4O76KTk/JCqhO1aTJfP3/z9WCjm8xpjQWL
         jrwQ==
X-Gm-Message-State: AOAM530JYf5u+IBiTqGr75xbKYJb9Q7NPWQ//+EJJrimiuZdtbuc2TU+
        0momjfygLrAR710ru141l2pY0t1z4Nn4yJTxlx8=
X-Google-Smtp-Source: ABdhPJwAEYLfX/EXIy84w5OX2KUBDleBo0BpharMmRB2mOLpv3Spuk8NBADL0TFZOa8QEpCaRXpU1rHlP4NKX2QbgjU=
X-Received: by 2002:a63:e108:0:b0:3c6:6833:9192 with SMTP id
 z8-20020a63e108000000b003c668339192mr18772598pgh.616.1652300486658; Wed, 11
 May 2022 13:21:26 -0700 (PDT)
MIME-Version: 1.0
From:   Jack J <jackjosepheq@gmail.com>
Date:   Wed, 11 May 2022 20:21:13 +0200
Message-ID: <CAOKoJwV5LCcs976RF=Ujh=rK982dY2twsn6h3skMit-9wwoHBQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0gDQrXmdeV150g15jXldeRLA0K15nXqSDXm9eh16TXmSDXmdeo15XXqdeUINep15TXldeo15nX
qdeVINei15wg16nXnteaINee15zXp9eV15fXqteZINeU157XoNeV15cg16nXmdepINec15Ug15DX
qiDXkNeV16rXlSDXqdedINee16nXpNeX15QNCteV15zXkNeV150g15DXmdeq15ouINeQ16DXkCDX
pteV16gg15DXmdeq15kg16fXqdeoINec16TXqNeY15nXnSDXoNeV16HXpNeZ150uDQoNCteb15wg
15jXldeRLg0K15HXqC4g15In16cg15In15XXltejLg0K
