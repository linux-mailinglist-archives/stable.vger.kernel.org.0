Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5932B18A038
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 17:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgCRQMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 12:12:02 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39790 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCRQMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 12:12:02 -0400
Received: by mail-lj1-f193.google.com with SMTP id a2so2150728ljk.6
        for <stable@vger.kernel.org>; Wed, 18 Mar 2020 09:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=HXE6tstiCEJgLEvZqX/al+c2Uj3U9XPUohG/1iBPeWI=;
        b=JcrsybK+GhtoozObFhHQNm2qVIECfp3zVQ8WjsyoyCHalUG6AK3pNkobr0Jtqd5nL/
         DXOtczNmjZZj16r50tRvzUv7FtVXqhFF8Dli79k0QRjyDBMCfg0pq9f1Xlkxjzu7VvXN
         BNiPGhWJjuDQMs+sY2rOmhDqLR49xWsKFFz9vsbRGDijpmtIkAOMIUbPOCB75NwMXhJI
         qGxHCZYqfvxCFA6G5vNT8Ke0FgRUKQMqguP2bTAkz/xnBEf8rUjE+CeOK2/MWpsU/qxE
         8fdBJsIQsN4rHzxog5w49D/VBegqAw/0vwnjhHwJAUuUfPETMHae6L42DXniW+629nA/
         oUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=HXE6tstiCEJgLEvZqX/al+c2Uj3U9XPUohG/1iBPeWI=;
        b=E8m/IjkMMXESO7DxDBVY5+KlrcjOBA60ryYQUZe+gnUKYTFS7+/SRXYF9SYKJt1r1l
         v9/BayUE0fLyUhOYLC1zkID7ChFlXroCqCZzl86pxMeZaOKsL4TaBUfo7BtXsPZFmnVe
         5ssjgR7X5vfpXFtz5kNwvXcheMqxNQnqK3S4zvE12Ka9K5+QiX8oxqOfUJA1Ec72Uw2u
         FExQri2ncUT4arQjaMZdNN7PlaQNqI24oRG4r49+eXb5lgcU6LHpVsH2dDmJUGMGD0WO
         3rGjJa3rCXkCQExn2c6y6vTJsTMuO3wOw0IV17L0+FwkP3KtnMgSrTp8j7930MrB1lLd
         F1YQ==
X-Gm-Message-State: ANhLgQ0vQLBqYy1+ortbznUdhLTrikWtixAGI0hL2EKYRewcds+KwvIi
        KFnZKryStvCXFuyF8/Fm6iud+uN8FlPJbNMYCWToiY50
X-Google-Smtp-Source: ADFU+vsdCj2Uxao47iIExysLRytMC5fZufqsCx3ZtPck1zyU5JxRUcqlaDjK3k/sKEJ8eZ03SACfoaZnddgAqnT4qak=
X-Received: by 2002:a05:651c:1058:: with SMTP id x24mr2940012ljm.248.1584547920762;
 Wed, 18 Mar 2020 09:12:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:68d7:0:0:0:0:0 with HTTP; Wed, 18 Mar 2020 09:12:00
 -0700 (PDT)
Reply-To: begabriel6543@hotmail.com
From:   Gabriel Bertrand <emailbox279@gmail.com>
Date:   Wed, 18 Mar 2020 09:12:00 -0700
Message-ID: <CA+6K8q-RpsC8Fcde9Rs7pwJJcYwpKaO6ebXQwbK7J2DF3H5MOg@mail.gmail.com>
Subject: hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0gDQoNCuS9oOWlve+8jA0KDQrmiJHluIzmnJvkvaDlgZrnmoTlpb3jgIIg5b6I5oqx5q2J5Lul
6L+Z56eN5pa55byP5LiO5oKo6IGU57O744CCIOaIkeWPq0dhYnJpZWwgQmVydHJhbmTvvIzmiJHl
nKjms5Xlm73kuIDlrrbpooblhYjnmoTpk7booYzlt6XkvZzjgIINCuivt+ihqOaYjuaCqOacieWF
tOi2o+iOt+W+l+mBl+S6p+WfuumHke+8jOivpeasvumhueWxnuS6juWcqOS4jeW5uOS6i+aVheS4
reS4p+eUn+eahOWkluWbveWuouaIt+OAgg0KDQrkuIDml6bmgqjooajovr7kuobmgqjnmoTmhI/l
m77vvIzmiJHlsIbkuLrmgqjmj5Dkvpvmm7TlpJror6bnu4bkv6Hmga/jgIIg56Wd5oKo5pyJ5Liq
576O5aW955qE5LiA5aSp77ya6K+35LiO5oiR6IGU57O777yaPiBiZWdhYnJpZWw2NTQzQGdtYWls
LmNvbQ0KDQoNCuaIkeWcqOetieS9oOeahOWbnuWkjeOAgg0KDQrmnIDlpb3nmoTnpZ3npo/vvIwN
CuWKoOW4g+mHjOWfg+WwlMK35Lyv54m55YWwDQo=
