Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A973D13CCB4
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 20:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgAOTAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 14:00:33 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38834 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgAOTAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 14:00:33 -0500
Received: by mail-pg1-f195.google.com with SMTP id a33so8624072pgm.5
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 11:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=Ui/LHNZMNuxDFZkSvHwprhXUW0PBXFzrYgBctU22yUk=;
        b=RFotpcZpcL068jSpVnwAw7Tb0V79YklyPf9r3U9n25i0uSCdk9GdBJmSkYKXEvDqO8
         uRAcs0iIKe+cgrjUKiH+bkdjcK561SNGQu2VzKNeJVnn0CdtLMeANvj7mPlEx6DKKuv2
         70r2yu17/FLoRJtCxmhZKz7qIaGBMV1LKdFt4PQcmh3OCk/ScgOfnTxnVFGdXs65XYP+
         oz6dl1C0L3FMgT/9EjiyZvQsHhiBhR0v7FMdKJccAZ53g+KdvpPBp3Cf78+AQwGCbDQS
         fnzjDXK0yHA7r/qCyHXsii23baUamYtRxDFWeQvqBSxmkOiO/4y/SD1sWQEkSpdm5eFg
         7Kyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=Ui/LHNZMNuxDFZkSvHwprhXUW0PBXFzrYgBctU22yUk=;
        b=ZP1T3Gn8oTSxZ35nF81VtvslVNhJoaGMVPFvoHWSSljTLDO7crpsPutrkSS3IOQdIe
         tO8h/UNn03kVSxKapetNvL9CUUIoMXSBWqqTUV0kKBHjlnN6qUBsk8x4arzJiPgHnjk/
         xiSYGuQVdzdOHErv75Ws1lrv460uxGSyf0BDtxJHX+SpBdYVWrhSPG2s0Xslb7AYKpbp
         IlpgOYx2Tc9u0d/YQ0gSsC3pBJvIx4rng07Wzacl1PY8Gm4Mj+/8STHQEZ+4bt2I4f0q
         4afvs5pVUxlv+ERymOsf4oi+zuknDQnpE6PeRjtSAlUCxBGVvmV6Tc43ciDY/OD+hfzO
         arJg==
X-Gm-Message-State: APjAAAUYdOLdcXhVnVc851OzJH9vtbWaJGzsZB+bVhP2Q12lBeM2svnG
        O/KMMa/nW25EopFKt69pubUkC1b9D38=
X-Google-Smtp-Source: APXvYqwy72jUsm+n4BdxGsJTuXS8ExkE3jPC6QBNdo0J7hKBsao31DPs/GIz18rTX1MewhKPip3TWg==
X-Received: by 2002:aa7:8d14:: with SMTP id j20mr33695263pfe.207.1579114832707;
        Wed, 15 Jan 2020 11:00:32 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:ddf6:ea5e:27c4:ee20? ([2601:646:c200:1ef2:ddf6:ea5e:27c4:ee20])
        by smtp.gmail.com with ESMTPSA id b19sm22066961pfo.56.2020.01.15.11.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 11:00:31 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: Fix built-in early-load Intel microcode alignment
Date:   Wed, 15 Jan 2020 11:00:29 -0800
Message-Id: <5C216684-6FDF-41B5-9F51-89DC295F6DDC@amacapital.net>
References: <CACMCwJLJCA2iXS0QMKKAWQv252oUcmfsNvwDNP5+4Z_9VB-rTg@mail.gmail.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
In-Reply-To: <CACMCwJLJCA2iXS0QMKKAWQv252oUcmfsNvwDNP5+4Z_9VB-rTg@mail.gmail.com>
To:     Jari Ruusu <jari.ruusu@gmail.com>
X-Mailer: iPhone Mail (17C54)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jan 15, 2020, at 10:46 AM, Jari Ruusu <jari.ruusu@gmail.com> wrote:
>=20
> =EF=BB=BFOn 1/15/20, Luis Chamberlain <mcgrof@kernel.org> wrote:
>>> On Mon, Jan 13, 2020 at 09:58:25PM +0200, Jari Ruusu wrote:
>>> Before that 16-byte alignment patch was applied, my only one
>>> microcode built-in BLOB was "accidentally" 16-byte aligned.
>>=20
>> How did it accidentially get 16-byte aligned?
>=20
> Old code aligned it to 8-bytes.
> There is 50/50-chance of it also being 16-byte aligned.
> So it ended up being both 8-byte and 16-byte aligned.
>=20
>> Also, how do you *know* something is broken right now?
>=20
> I haven't spotted brokenness in Linux microcode loader other
> than that small alignment issue.
>=20
> However, I can confirm that there are 2 microcode updates newer
> than what my laptop computer's latest BIOS includes. Both newer
> ones (20191115 and 20191112) are unstable on my laptop computer
> i5-7200U (fam 6 model 142 step 9 pf 0x80). Hard lockups with both
> of them. Back to BIOS microcode for now.
>=20

Hard lockup when loaded or hard lockup after loading?

> --=20
> Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F1=
89
