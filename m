Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1192353C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390455AbfETMdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:33:55 -0400
Received: from mail-it1-f177.google.com ([209.85.166.177]:37750 "EHLO
        mail-it1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390464AbfETMdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 08:33:52 -0400
Received: by mail-it1-f177.google.com with SMTP id m140so22811995itg.2
        for <stable@vger.kernel.org>; Mon, 20 May 2019 05:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=q9WQVU7+He9MNNOphPIQ/IZsr6T/EMPia3Dyh05vK+A=;
        b=DT4nwBWqh/Kh9KfrvruuGnEmnBNWo24d1cHdc2adnLAxoYB+xstFQt1BNqppD6cmbR
         zQ2vZ55H6eR4pRq9g+ktGY3xtHn7oJXIO7+gsZw7z0aTjGK4djZJ0tcBKYiK4543fXUb
         TyUlLOv73oFcZsiEn9kS4UdAGue9aRM0k0GfpZ8Tx+I6yKyKhIF1U7DAKzo0ss7ZAbex
         hXcytclWpb4fzrATElxXfk4ahZVUoj4XPxQOg9Ypj4jAkuW0vY6OoARYv0/+raiCa/gX
         QYxR08NyEV+ehw6Tyo79ZfRBEEjyL6wGN8bUtOlhRsl94G02dSlQ1cWBuRZbFUQdyTnE
         Y4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=q9WQVU7+He9MNNOphPIQ/IZsr6T/EMPia3Dyh05vK+A=;
        b=uoUGq1AUU/el8lKAa97ov3oeqlJ2uZpD/o87WpJG04E+htvVlsU1yp5JA+6dyrg3Fb
         Rs7A1AAKw4nz2l96b54yXUOTckJ8UI8oMf+RdCRphLtbwd8ePjS64X30iO1vOnZP9sWX
         HOLCE3Za6azqDjp5q9tbNgqm7T0uNt4ul/CzxlAImpK6OAYvYG1ZlL9LZdZYYCL3R6i7
         7bpWKjuKmjTdwjP1mmTAKLo56HPhOM6vRQud7YGpKwlW2iDACAv/v1h42Wjc0FHUrRyS
         rwQliHm1Vjcq0vXacTO3VZ2aEE4EeYnkcvbFivzAFYDXB+JmSZiAg2lzLAdUpBV6pK4r
         +MyQ==
X-Gm-Message-State: APjAAAUqH94kHWCO4eI651EKTTYx0CVnkIGGeb4uu1s9EYUXXGtJKqIy
        isMLG0TIPAivdptDpm+AhXgl0Aro1Z8faCCQkvfhtwuS
X-Google-Smtp-Source: APXvYqzYhFXoUFHqf72zO7t4yBZkMAF/x3HV2KN9HB+MflZyxaUDTkdd0dVZFqp90qtE2+8rpdLYH6HmTXcRfNnNvi4=
X-Received: by 2002:a24:e3cb:: with SMTP id d194mr28207446ith.100.1558355631420;
 Mon, 20 May 2019 05:33:51 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 20 May 2019 07:33:40 -0500
Message-ID: <CAHCN7xL9xy+kTu2hunG-cfG_-4FJ4-=BLFo1XRj5vh+8OTO7Yg@mail.gmail.com>
Subject: ARM: dts: imx: Fix the AR803X phy-mode
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply  0672d22a1924 ("ARM: dts: imx: Fix the AR803X phy-mode)
to 5.1 stable branch.

adam
