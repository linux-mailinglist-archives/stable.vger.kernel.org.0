Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED6256235D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 21:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbiF3Tnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 15:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiF3Tnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 15:43:52 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA8D31204
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 12:43:52 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b2so377422pfb.8
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 12:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=wPCVy5KcY9U5iX1ZfhqZf/jxu7otMbjA6yLVHmF0z58=;
        b=OTMM9+xM0tGn7ofon+BaJe9obKyoX1Ma3OplxZ1sJduQ/vHZhu9NqetDPPLZfL4kFO
         5SzVpWLfBalkR2YOobk5J7suNQdbmv6OJmjyJCHu0yHEqxLcbw1WcO1hcDA8VsV4xyxr
         o9MCo4W3N3udW1MIrxkARLUzOvT65p1Wlw0D75YAXH1yW4omWnc8O/E0ikQepN+YXzcQ
         DzZzsxR+i8RfvLDXtKWQ2e9QhXbK8CT5Vx0R5Xy+Unvifai6gii0kxke7qKKY1ptgGgD
         XXpX8QrwwZ01RzKVK4cVZty0aiy30XHm7NiIYdKgV20q+tOiIxdn+Z4tm4RZtACQ4t81
         hrZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=wPCVy5KcY9U5iX1ZfhqZf/jxu7otMbjA6yLVHmF0z58=;
        b=0icfKBVFxcmRpB2sCj9FVDVrFe7MsujvuuNlnHIDAA0SCW4HeS+Wk5K1OLmX2rebdi
         oyfvWF6QXcOql4SYaMGBLpSOXogYlWnICNdIXcWeOHoWTwt0bp7ayrzpbzqQcXUKNevZ
         Y9IveIQmjaO9u6WOSAmqNmVPq7+QaeKXMOTOzIhUF5MqZb6v6uX9KepwPKdTwi4a9wmV
         7149+qf/6fLCrQgx1siyUK+A8f5zNyq6B//W3FJ6iAuaGLYj8pncUtzRBTYSI8HcYRsC
         +qv+TqdtfhQt03YOz9zUjE7ctQ004KFhO+ullNHvsH40LDbAiP4R+yNDgDr/d0NOqtVZ
         i9OA==
X-Gm-Message-State: AJIora/btX3UsGwVmMRQ4kNwwxLxYDxHueBDHf/AI8RIp0MNEsbcnjZ1
        2PwdoI9lNFRI5s1naxXWVVaMRKT0RQEQ9k3VzlM=
X-Google-Smtp-Source: AGRyM1tFUwXuGRZhYxveBLA5TY0rHLqw8ejABxVkNbb5vh7Wy7D8Z8BpSxIg5KHuo50iwVT0scGsAfHVWBQg8Y7saK4=
X-Received: by 2002:a05:6a00:16c1:b0:520:6ede:24fb with SMTP id
 l1-20020a056a0016c100b005206ede24fbmr16309527pfc.7.1656618231847; Thu, 30 Jun
 2022 12:43:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:23c9:b0:69:8734:19a4 with HTTP; Thu, 30 Jun 2022
 12:43:51 -0700 (PDT)
Reply-To: sgt.kayla03@gmail.com
From:   Sgt Kayla Manthey <sherrigallagher36@gmail.com>
Date:   Thu, 30 Jun 2022 20:43:51 +0100
Message-ID: <CAJC-JhiOzV=uzDABer0vadu_qQPPP6wYjbTCUURs7RyfzAX=mA@mail.gmail.com>
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

Hello friend.

 How are you, I'm Sgt.Kayla Manthey a US army serving in Iraq/Syria, i
want to make friends with you, please write back direct to my email
address (sgt.kayla03@gmail.com) to enable me to tell you more about my
self. I expect to receive your response direct to my email address
because i have something very important and private to share
 with you.

 Thanks
 Sgt Kayla Manthey
