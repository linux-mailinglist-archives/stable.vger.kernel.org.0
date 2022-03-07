Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0D04D0801
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 20:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238682AbiCGTzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 14:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbiCGTzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 14:55:42 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926F75BE78
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 11:54:47 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id d15-20020a05683018ef00b005b2304fdeecso3297030otf.1
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 11:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=zI3YMoABJRyR+odt0AbJrQOCfTLDDuwNt2ksIU5nkFY=;
        b=ecbf2sOA5U1gr7faRJ9tM3yci8PXmYAAC1VosEPK1blYvQe+D7Meo7NZoIkGLHAU0l
         fwQmFVD62/XyAYWXKUA//N4C4F4nNJNsblZB1Zh32exs3ZDzRFoZ7kL3SdWsjfcqZ2kV
         rSxGOM4SHiZ1bq1Mzw2JsGrPHvf7QoC95TDSExsa5dI/1CFLla1wt/Hkr23mh1Sgve+n
         nR5JnDURPyQBAuhMDiWv5RiWgcySfDhPKenDcpc53lFH94IEP7cxKFMWzBn4PqGrPgzx
         Jjn84wHF7QC8mvNxcz565nCoIHiOceK2j0hTGMexi4K2ZstWoEpl+fuxcbMo9nN38NFv
         b3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=zI3YMoABJRyR+odt0AbJrQOCfTLDDuwNt2ksIU5nkFY=;
        b=torHePt4y+RN6lYdPgVT9jDWKnWTcAvtUawY+ElYI4sVgRfFtTX95unpE8FDH7XKe8
         JdZ9O+vbbza4u7TIaaE6NEFyxmPzEQ3WOOnxfEBrcu9pHPC4C7B5YKGB41hx72pb+YEN
         TidE7+2UB+Ikw4bkgP4mreRa+HoGDWahljOvypJtz+PqMWKqFzdgGSH/CyGSQo/Wrldm
         AMr4sK2SltTSt7aUXvYgno6gQ64jj//iuq8X7a6TrIYs4bQCh014pDrnP/dysQv1E8o0
         3xvU9B7FWPrIwWG+8lTsHNs8T6INxPZOolZmPfZRcwMCPEWIzh0bX0rDGxMVb06MxRLj
         YzCg==
X-Gm-Message-State: AOAM532tjd0pMkehNsISobzQVNLDMYUlJeDHmfnwILTf+LkNaekScDrk
        o//2TggPpAW5bxZQUcFh33xY/csZiPwr1GbHxRE=
X-Google-Smtp-Source: ABdhPJzPM6iKZ1ZK+JuuJPVej2RumekfRAOrSDom/vSk7bl6AfSw2NDoTr6vg4pETkspgKtjeWJLf30UNXoWq+FAnhE=
X-Received: by 2002:a05:6830:22ea:b0:5b2:35c1:de3c with SMTP id
 t10-20020a05683022ea00b005b235c1de3cmr3094842otc.282.1646682886985; Mon, 07
 Mar 2022 11:54:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a4a:b002:0:0:0:0:0 with HTTP; Mon, 7 Mar 2022 11:54:46 -0800 (PST)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <drivanrobert81@gmail.com>
Date:   Mon, 7 Mar 2022 11:54:46 -0800
Message-ID: <CAJp5pimhw7DZzraBZi0ghbDgDLuEqo8B1L_m-P3cjsk5ti5qOw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Please with honesty did you receive my message i sent to you?
