Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F1156216F
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 19:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiF3Rml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 13:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiF3Rmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 13:42:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF4B1107
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 10:42:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w1-20020a17090a6b8100b001ef26ab992bso202430pjj.0
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 10:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=Ubr2wcibTd+fQBEY8F8o4cshSIVA1KMmACRrREaFjTE=;
        b=UNj7H9ZUliiZCc08ev2OfHyfDAFkEr3UtBGlACxjawVAU1bhSN04N+iUycNDsrJIqz
         K6IBhaMPt2mfCaoRmbxf1VPKToiCz9vFWcV8JQjGGp6rPneWgvSUe+3J1uDV8dyOQUBJ
         2cmvtnLPBZiHY7st1OBT8qtLi7B6+uZtiBC+kiyghy8mCqSs+j6Y78zDWnFs9PjwP23R
         0qV985BPaw2FiUpQu+KbU8E6TOPoCr+ZovIL8FQXFPaFWGAYLRzVFtGe7CeQIrUhJZx4
         VXzvdThzFtCNdOqUwkHA6uLHE7Wqa2BSJmY+JjtgN4RPqd9uIIkJ3gNMmDHMb3yaeVDn
         kIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=Ubr2wcibTd+fQBEY8F8o4cshSIVA1KMmACRrREaFjTE=;
        b=d3gdMSMfqx2uEVMqh/p/SF3RbjOfvqKYiFJcS7fStcrP/sDZ/e8w+YcJLOj1Ta2jG4
         k6STcmyit9/SgPTrMgwds7raL4jrZKOF2vz6NTwrgKUctaFFzGEeii3JcxlHnqxnlslp
         ahZspN+nM1dqRj8uY4hZ9F6yEXx0GF6LYSCKcteLRCRkYMckuJBzakG1j0RPQopniV4U
         HEqdqvfB2TJLkat3taeoai6HU+9hW2SEpUyMxAkKZP50UUEAYWETX67Wjn8Cac/HOkia
         dbEWV2I/9ryFR7d4ZCPOx+skgOFAukbfdHTZ/ahRvFRL4wX1RDc/8taxACw2fAp8OA28
         CRXA==
X-Gm-Message-State: AJIora8OJPZc0I2/cWM0QNh7Wsj1YnQuugdYnzl3jTEwyBvmNqJ0l0CD
        Brq9gQBWUXaILqVKAOkVTJ2LDxPY5sKMQQzCrxI=
X-Google-Smtp-Source: AGRyM1uUBdRMdq/a2tDeyMqV5w8WDQG7APYGREphxgO+DWXN2uzyRKeRytDAjQFGH5UITDMY5CzJrin0sax8VC4zCRo=
X-Received: by 2002:a17:90a:f318:b0:1ec:b74b:9b82 with SMTP id
 ca24-20020a17090af31800b001ecb74b9b82mr11489286pjb.198.1656610959761; Thu, 30
 Jun 2022 10:42:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:23c9:b0:69:8734:19a4 with HTTP; Thu, 30 Jun 2022
 10:42:39 -0700 (PDT)
Reply-To: sgt.kayla03@gmail.com
From:   Sgt Kayla Manthey <sherrigallagher36@gmail.com>
Date:   Thu, 30 Jun 2022 18:42:39 +0100
Message-ID: <CAJC-Jhhm5T_vFq93gquQQd=_G7bqdJkWtzihmZRRPyb_S+PQyw@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings, I am Kayla Manthey, I'm contacting you because I have
something very important to share with you. Write back to enable me to
tell you more about myself. God bless you.
 Best regard,
 Sgt.Kayla Manthey
