Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864E94CAF4D
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 21:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbiCBUFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 15:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiCBUF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 15:05:29 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027C0CA300
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 12:04:46 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id i8so4514651wrr.8
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 12:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=c3P4r2Qz0VdfRBuStsXVpcJEgpWE5t0Sgi1SeeHIl+U=;
        b=UUcfWpZg3FkNMpINJToau4nSVZxSeyX17VNbdfPdcPKlbuX+BVkC5kmDmhAqtWYsqM
         L2pZ+R7uVjhLHFhNUZVOOgSy4nteHjwJVGIen1hvW7ZNBVrF2SWo+JuXhZGaTPPbO0zw
         1L+BaxthghoSzvVL3tjwxQSb1uVZTIj8PTH3iVCSaHHszwgo9G3mImKE0W5dX+tox0Kw
         cjVcc6vUBzWR7oE5eBsGFgaFVQBBFSoNuHi4Y15QBcdj+f335thvHryj3P7bkl67ugOQ
         Rg6rsORY6CHspJPBum35GEfAxyF9ogHyYuHpZvupmKBE1ry3F2aMQFoQaGmauS/ws6Jo
         aqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=c3P4r2Qz0VdfRBuStsXVpcJEgpWE5t0Sgi1SeeHIl+U=;
        b=6+zbaGupn+O+OneFO1GFw7SeuLY6BHVaPndOeFQ8ydeaJ8xWfQgrB2+zofcIz0LyGI
         edkZiBPmNUy6FNej0LVCy7XLYiivuS51uIkC8uAUEwW/eTxZZ/v5J7Eu/nv0l0BABz2C
         jx8/haRnxF7ufYdt9shmV1pfujlzJP7b340SU3WSpFDKYibpnBuA/WnGHWdOVF7HNW6a
         3gMlCdc1i4pPubaCOuRc/JMrVijQ/z7mCoHfgSvE/88qdZzqzd4csMxkiazblEh9rjN6
         jRUxGJGnUv+o2AeoSzEYOHKsOEtQFXqJv4fScJS3LZvqfg+QEm3pGhJrChpY07Gc3/nv
         7OAg==
X-Gm-Message-State: AOAM532XuImkRRs4YJwIdXxSOaNdv9d6lZIneWQ+as0ywSqUiK+NEWgN
        fTd0odWaGZn2GGDLdvhfF1Rab6YVvSyTFMPP5ks=
X-Google-Smtp-Source: ABdhPJwxwsIZYaD93zT4by57tjzuXMk8ETleBxdGDhAq1N2wHoBWuP5tPyNGcGrjVyg9H34i0QXeA4WnQcGzaS4fJZE=
X-Received: by 2002:a05:6000:1846:b0:1ea:7f4d:c56f with SMTP id
 c6-20020a056000184600b001ea7f4dc56fmr24205850wri.25.1646251484681; Wed, 02
 Mar 2022 12:04:44 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a7b:c00a:0:0:0:0:0 with HTTP; Wed, 2 Mar 2022 12:04:44 -0800 (PST)
Reply-To: info.tiffanywiffany@gmail.com
From:   Tiffany Wiffany <luis.fernadez0007@gmail.com>
Date:   Wed, 2 Mar 2022 12:04:44 -0800
Message-ID: <CAE3RqRYK6yVwCmzaxTNMG1ud+5=s-ERNDMcYi+JHYR3aWHuGFA@mail.gmail.com>
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
Please with honesty did you receive our message we send to you?
