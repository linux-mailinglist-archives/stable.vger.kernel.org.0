Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BB92F8B55
	for <lists+stable@lfdr.de>; Sat, 16 Jan 2021 05:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbhAPEtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 23:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbhAPEtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 23:49:05 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697DFC061757;
        Fri, 15 Jan 2021 20:48:25 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id l12so6004872wry.2;
        Fri, 15 Jan 2021 20:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:sender:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=ty8Pzs8YnsPvOci6WSbfq+yaGMF9rXTaArqQK+d4Yss=;
        b=CBcjlO/fcJ5YzRCXVtNHVKr0fLJclV9xuxFlWPTntAbgyK0s32li+JgMt+asYOfxsz
         q3Pik8yWCwY0ZPpSPnxuwbzGppZL3vFMxcfDyaHSoNjcyq53Y5QZ7yfTugsxImGS1vVr
         AUxwp3BUbYiI73drDdr1GoD9Q/f/EECkOyCy1DD56p76UatWF2co4Zo7wqD8/sTFYSCy
         kwMguKUiqKoZ0+vdo7G7Unr9uCdyNrQlIAJ3zYXpEXrtGtC+0n42nznVf9kUHF9EV/yZ
         z9/DdKNGME4G5wNVHWNqD23adRpp2vqPzpV2aqfQ25VNhwqjr/L6buFxPpmP7R6ybkKy
         K9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:sender:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=ty8Pzs8YnsPvOci6WSbfq+yaGMF9rXTaArqQK+d4Yss=;
        b=LtaRB1JvWFRpEOJfo6tIl92CW0JgVo2IBuw8bxFLqwI7o0p3sL98nGspHAGIbqKItX
         ny11WPvuxMLYCCvFSD91Gqbyo/buAxxKbXYETMPetxkjsfYThu2tj7CYQL0gaENgwa6y
         6QgdiHcaA2hVHMyV4smL6YGzuamaGzivOU9f4PhIONb/ZpdFvSkkDs/7OqDzKHcFrVhC
         HDCUV3hAEx6idhZ6NfaiFal67AuneYYVQATOWEmIHQGRfZNMeUcUtIKrnff9MKB8e2oS
         P1LmdrdgVtPz5nnf8jUeZ43f8vG8ysVb0hFybLUuSjv0KI7cFpEEQors+wwQsmes/1S2
         8RRA==
X-Gm-Message-State: AOAM5308YjJ8Vu1uk/zcf+8rnHyBVXCVAbJvP9ASWfodpA7tgSq/sE4y
        chx7EFrizq40CFw8n2+uFdw=
X-Google-Smtp-Source: ABdhPJzTVaod61XbZtH99uXC8vYGhbt0lZXEHKBibo4La7QBUPQVGXiPhuPEYPfFazjl9qBxuugdFA==
X-Received: by 2002:a5d:6751:: with SMTP id l17mr16172047wrw.73.1610772503927;
        Fri, 15 Jan 2021 20:48:23 -0800 (PST)
Received: from [192.168.1.8] ([154.124.21.107])
        by smtp.gmail.com with ESMTPSA id a24sm8224297wmj.17.2021.01.15.20.48.21
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 15 Jan 2021 20:48:23 -0800 (PST)
Message-ID: <60027017.1c69fb81.5efe7.944d@mx.google.com>
Sender: Skylar Anderson <khadykasse98@gmail.com>
From:   Skylar Anderson <sgt.skylaranderson876@gmail.com>
X-Google-Original-From: Skylar Anderson
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: hi
To:     Recipients <Skylar@vger.kernel.org>
Date:   Sat, 16 Jan 2021 04:48:16 +0000
Reply-To: sgt.skylaranderson876@gmail.com
X-Mailer: cdcaafe51be8cdb99a1c85906066cad3d0e60e273541515a58395093a7c4e1f0eefb01d7fc4e6278706e9fb8c4dad093c3263345202970888b6b4d817f9e998c032e7d59
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

there is something important to tell
