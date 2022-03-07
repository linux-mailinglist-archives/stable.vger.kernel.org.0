Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492394CF2F1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 08:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbiCGHum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 02:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbiCGHul (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 02:50:41 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52C360D99
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 23:49:47 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id 9so10911479ily.11
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 23:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=8J38Rv9T88O8LznVLYDAMzgkYD+RbVqzgKVGb2a4ys8=;
        b=a7Z24VcVWgLEWrBVhd5vl1tH5VD1O1GqSYNkCn4eBojvD5ECXvdzBwC7n7fwpROGrb
         QlIQ+IA7vREnxjZMagFOAY0DzSewSBFRv3HIRRPBZ+C2dIPaHzUgtIWKzS62pfThu4qZ
         A9ZWbB1dNsxc8F1/yGubQEXpk3OzXPIQZqzQ7t8b+dFGn53FQvkMfJjhJBGMQKoOr+43
         o963XM+voTJ9RNjkKdVuMfTXSsnwjBmcTkHF7LUwUOndROUfZmPpY5ub5lwe3h537nIm
         m0tS5kkqF/evzR5JabSj7S6LhbhVJvCLmKQGXSxX8k14dQaCw0PmoQTJtE9X7n4JuLNn
         fDLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=8J38Rv9T88O8LznVLYDAMzgkYD+RbVqzgKVGb2a4ys8=;
        b=sdfgbV+l23h3HENFfZdJV6yXgFECnsnFn7ms0gk9pbKtnWpxL+ndBkKid57WTtInVC
         CYmcnvnNtyBcms7eJGXNm92VM9WnM1ZccCUIESEu5nNNm0ds2jcGQlYdBTIbv8BEwnul
         fmkJ6J7kUkjY5mKO9qM+BvvxNc8npQJ6O6VHuqKVnYypVN6rwZIS94tYv63slQvTCxDg
         TgSyovKwKUeg4PqskHzbcIBfqeA0IFyoEv6ZrzmseXIJ1djW267lovOsLHcxHUSXZvHg
         B+ayoSvZin9ru6eePdDo83cGF+OYIFzaMLnx/jw6IjkjlE5jTwdDWc+nXgGatz2RQOI6
         f51g==
X-Gm-Message-State: AOAM533fp8PYS4sjx+EaIOaUqZylP/adxJioI5DEYaOkmS6reVvoBmMv
        qBv857v5M+dubau3dNthgLKy26hbHacmyncTALI=
X-Google-Smtp-Source: ABdhPJxdVrUzznIqTgfkGugG3mWbuN9Z7w+aw5fQqUdMuqN1eqO8Z/wqNAZIKvB8fZMHtI5VXHj3IkyAGGw2TiP3GSc=
X-Received: by 2002:a05:6e02:19c6:b0:2c2:5f51:c81 with SMTP id
 r6-20020a056e0219c600b002c25f510c81mr10220279ill.57.1646639387317; Sun, 06
 Mar 2022 23:49:47 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6e02:1e0b:0:0:0:0 with HTTP; Sun, 6 Mar 2022 23:49:47
 -0800 (PST)
Reply-To: fb5485370@gmail.com
From:   fred benson <fb5088646@gmail.com>
Date:   Mon, 7 Mar 2022 08:49:47 +0100
Message-ID: <CAGY2EXMFM7dEGXA7WdUAveaRqQej8f_kGsKQWJDpN=m+8syh-A@mail.gmail.com>
Subject: dearest
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_20,DKIM_SIGNED,
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

please get back to me for more information on the transfer.

THANKS
