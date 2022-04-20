Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76C3509318
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 00:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiDTWqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 18:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245190AbiDTWqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 18:46:15 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FD6275C6
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 15:43:28 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id f17so5511596ybj.10
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 15:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=XsschJcLfC39ayLiVt/DNcvB/JlWwZ35CFIHFiyvyxI=;
        b=eTYI+MSq3yXhEya/eGWOwnhCVi4gIwdKwo/kVa9nWzLxczOgPEpILd+KOdW1c01aEs
         AEl/TdGgmi0soLfOZHMgPQoWI9FBOi67WTI6Dk2R5WklITHSFoRGVJnICa5WmOEZHyV5
         WwzW8lZvbbafMcl40VrCSmYZP0+Y9Q7oAHc/QKQqfWLLYlKrHj7Kho04gBLhqh+WkNaL
         eQzl4FeTDvrVbj7YIjrsxwl3KpVsl6ppV1LI6oR5KA5HOoE5U3I97lVJtEvyRu8Opza2
         kfTrCue0pYZ2lrmUU1rpxTLyaZXy97K8E38yD8LiEvXkHkRt/KrHXuAhPx48Tt3FIt43
         YaCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=XsschJcLfC39ayLiVt/DNcvB/JlWwZ35CFIHFiyvyxI=;
        b=o7NbYSCA7P6AbFqIqret+eEvAcwDBzt8saTV88r7ulxT2jhdScy3VOFsvUdiLtWDOk
         RRF5xnmKZfuOUx1/LGvEV6Px2cCejcQw+Ds9E+FQWaK8FNP9UT5b2aFW3NXuJzfWPbRc
         0YVBGwrG7x7b80Koxed37RM6SZJ48eXEQyb09DAImfb53k7YylB1YcC5jNbEWAq1790T
         S+P6hmn/+5aZPu5Bhhzda4anb4fUvXHZPxzlVSR9giUmzbjq6PProwUAPsouSFCnR2NT
         VvFK5JymDFadcP3+nYO4xRzKlK+1BYteTyIC8+M7y7ljcMqyFyjX1BHSB4TuuV/OFGbS
         qtzQ==
X-Gm-Message-State: AOAM530lvy78JwN2xfIYwtF8/zplinAo0FDFB3naZAxD8KiroU6sEojM
        3lTSF13BP8Vhu2Kv2ePgbn21D7tV6EjbeUDLD/g=
X-Google-Smtp-Source: ABdhPJygRxDgqc9X0ZjaN7Kn4zrwcae9R/X7n1tgcOSmtXa2Yr+ysL5i+25I4zJCSLvzAB5gpk22Os4PrmmpXM+8I4E=
X-Received: by 2002:a25:dc8d:0:b0:645:4344:61a0 with SMTP id
 y135-20020a25dc8d000000b00645434461a0mr9440732ybe.456.1650494607393; Wed, 20
 Apr 2022 15:43:27 -0700 (PDT)
MIME-Version: 1.0
Sender: bihalo1234tay@gmail.com
Received: by 2002:a05:7110:b29:b0:176:8c67:87da with HTTP; Wed, 20 Apr 2022
 15:43:26 -0700 (PDT)
From:   Madi Zongo <zmadizongo@gmail.com>
Date:   Wed, 20 Apr 2022 23:43:26 +0100
X-Google-Sender-Auth: RT2ML6qcB6B-bbAQrD8dhHfGD5Y
Message-ID: <CAM8HdsNxoPx=xDOvHrf39F2=cgE0_O=cU9oDExbO2dW7Aznt4A@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Dear friend,

My name is Madi Zongo, a banker in one of the banks in my country here
called Burkina Faso. I have the sum of $27,2 Million for transfer
which i need your help.  If you are interested, please reply me
urgently for more details. Contact me via Email: zmadizongo@gmail.com

Thanks and best Regards.
