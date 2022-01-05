Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4B4485B3D
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 23:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244703AbiAEWD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 17:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244706AbiAEWDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 17:03:51 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A36C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 14:03:50 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id j4so497647vkr.12
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 14:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ryYB5jKGadEi0k933ngWy9k9HXsrzqsuK+74anPVy+Y=;
        b=j90fCDUOmfg4rv7rXsz168yQFm/HFV9b6DCbFmaAgwTQwyec/tcsVKrbCwIR4/UmY0
         v31kR/8rtrCg7pWEBWQj3PBfZ7IlndcdjNEYGgcuB6LIDYWCXL7L8qFyBQHDm/qO7viG
         bz3LVX2G7HVVJ2WYlsDfM9q2CGvfGaCf8TdmutcNA9D8OkRfjcsdQQUrlvDro4ZSodum
         X+Rw0dFGFeTyjkY+w1FXsKtQUwe/NfpKGXwAFv500B7fbSRXI4RgtWa7BSo+u+YZfJA+
         rEWAL4V7Onw4euhPesN5013Zb9c0rL8zfCnf7pgtf9+68lxRcGWBrxmDzfezNXpTlFt1
         4V5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=ryYB5jKGadEi0k933ngWy9k9HXsrzqsuK+74anPVy+Y=;
        b=jOquaLkp9qS7vRaC9QhFFNhOVXWrmKFSiD+FWiLorgn1r/wYW695JsL2xPwPP7j4e6
         qYVCM6GP788RFapqqT4rC65kluYsmaIfwPGdUEuC4EMv4izTrKsPUO6xIsj7aVw14NHr
         gOPBRS/rKnUm5WS+qgmJ21EVNJjTFkXIltwr602J/PtjDIq5gxS3cWxq3Y3PKRVeP4ai
         WmD+o8tZdhtp6KYnwtiqExUs0osEPliqbjp5zJwUVfKTHiJ+9mgY9ST89UgC/kfYU5g7
         tFWjGWxpvvksG0UtjW3V3FUSZV9GK+7s6Vgsg3eFBtQy9D00OfBVMmfuZ/ZqUXpGvZzR
         9+gA==
X-Gm-Message-State: AOAM531rta73W2eVJpxH2C5uke8sqx8bk2zp/jVIE9QLl7d+IxrjHlC8
        JfXOwSMU1qHajzvm6mG9/u+Ou1EBAh8iN/QTUF8=
X-Google-Smtp-Source: ABdhPJyOtOwYm1Hl737NAoLs0Ycz1UPhdlQ/OX0mQ4W50+VtRpUmkeWWm/nKHDPwTergsuyZ6JIjHpkqebQbAXIvwVg=
X-Received: by 2002:a05:6122:c93:: with SMTP id ba19mr15025390vkb.17.1641420229095;
 Wed, 05 Jan 2022 14:03:49 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9f:2c8b:0:0:0:0:0 with HTTP; Wed, 5 Jan 2022 14:03:48 -0800 (PST)
Reply-To: mstheresaheidi8@gmail.com
From:   Ms Theresa Heidi <ddavidpetr@gmail.com>
Date:   Wed, 5 Jan 2022 22:03:48 +0000
Message-ID: <CAOFL=zvzdHKZv5bW5py2OXzwu8R_EYbBKOvvSUOV1Caisc4ymg@mail.gmail.com>
Subject: =?UTF-8?B?55eF6Zmi44GL44KJ44Gu57eK5oCl44Gu5Yqp44GR?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

6Kaq5oSb44Gq44KL5oSb44GZ44KL5Lq644CBDQoNCuaFiOWWhOWvhOS7mOOBk+OBruaJi+e0meOB
jOOBguOBquOBn+OBq+mpmuOBjeOBqOOBl+OBpuadpeOCi+OBi+OCguOBl+OCjOOBquOBhOOBk+OB
qOOBr+eiuuOBi+OBp+OBmeOAgeazqOaEj+a3seOBj+iqreOCk+OBp+OBj+OBoOOBleOBhOOAguen
geOBr+OBguOBquOBn+OBruaPtOWKqeOCkuW/heimgeOBqOOBl+OBpuOBhOOCi+mWk+OBq+engeea
hOOBquaknOe0ouOCkumAmuOBl+OBpuOBguOBquOBn+OBrumbu+WtkOODoeODvOODq+OBrumAo+e1
oeWFiOOBq+WHuuOBj+OCj+OBl+OBvuOBl+OBn+OAguengeOBr+W/g+OBi+OCieaCsuOBl+OBv+OC
kui+vOOCgeOBpuOBk+OBruODoeODvOODq+OCkuabuOOBhOOBpuOBhOOBvuOBmeOAguOCpOODs+OC
v+ODvOODjeODg+ODiOOBjOS7iuOBp+OCguacgOmAn+OBruOCs+ODn+ODpeODi+OCseODvOOCt+OD
p+ODs+aJi+auteOBp+OBguOCi+OBn+OCgeOAgeOCpOODs+OCv+ODvOODjeODg+ODiOOCkuS7i+OB
l+OBpuOBguOBquOBn+OBq+mAo+e1oeOBmeOCi+OBk+OBqOOCkumBuOaKnuOBl+OBvuOBl+OBn+OA
gg0KDQrnp4Hjga7lkI3liY3jga/jg4bjg6zjgrXjg7vjg4/jgqTjgrjlpKvkurrjgafjgZnjgILn
p4Hjga/jg5Xjg6njg7Pjgrnlh7rouqvjgafjgZnjgILnj77lnKjjgIHjgZPjgZPjgqTjgrnjg6nj
gqjjg6vjga7np4Hnq4vnl4XpmaLjgavogrrjgYzjgpPjga7ntZDmnpzjgajjgZfjgablhaXpmaLj
gZfjgabjgYTjgb7jgZnjgILnp4Hjga82Muats+OBp+OAgee0hDTlubTliY3jgIHnp4Hjga7mrbvl
vozjgZnjgZDjgavogrrjgYzjgpPjgajoqLrmlq3jgZXjgozjgb7jgZfjgZ/jgILlvbzjgYzlg43j
gYTjgZ/jgZnjgbnjgabjgpLnp4HjgavmrovjgZfjgabjgY/jgozjgZ/lpKvjgILnp4Hjga/jgZPj
gZPjga7nl4XpmaLjgafjg6njg4Pjg5fjg4jjg4Pjg5fjgpLmjIHjgaPjgabjgYrjgorjgIHjgZ3j
gZPjgafogrrjgYzjgpPjga7msrvnmYLjgpLlj5fjgZHjgabjgYTjgb7jgZnjgILkuqHjgY/jgarj
gaPjgZ/lpKvjgYvjgonlj5fjgZHntpnjgYTjgaDos4fph5Hjga/jgIHnt4/poY0yNTDkuIfjg4nj
g6vvvIgyLDUwMCwwMDDnsbPjg4njg6vvvInjgZfjgYvjgYLjgorjgb7jgZvjgpPjgILku4rjgafj
ga/jgIHkurrnlJ/jga7ntYLjgo/jgorjgavov5HjgaXjgYTjgabjgYTjgovjgZPjgajjga/mmI7j
gonjgYvjgafjgIHjgoLjgYbjgZPjga7jgYrph5Hjga/lv4XopoHjgarjgYTjgajmgJ3jgYTjgb7j
gZnjgILnp4Hjga7ljLvogIXjga/jgIHnp4HjgYzogrrjgYzjgpPjga7llY/poYzjga7jgZ/jgoHj
gasx5bm06ZaT44Gv57aa44GL44Gq44GE44GT44Go44KS55CG6Kej44GV44Gb44Gm44GP44KM44G+
44GX44Gf44CCDQoNCuOBk+OBruOBiumHkeOBr+OBvuOBoOWkluWbveOBrumKgOihjOOBq+OBguOC
iuOAgee1jOWWtuiAheOBr+engeOCkuacrOW9k+OBruaJgOacieiAheOBqOOBl+OBpuOAgeOBiumH
keOCkuWPl+OBkeWPluOCi+OBn+OCgeOBq+WJjeOBq+WHuuOBpuadpeOCi+OBi+OAgeeXheawl+OB
ruOBn+OCgeOBq+adpeOCi+OBk+OBqOOBjOOBp+OBjeOBquOBhOOBruOBp+iqsOOBi+OBq+engeOB
q+S7o+OCj+OBo+OBpuWPl+OBkeWPluOCi+OBn+OCgeOBruaJv+iqjeabuOOCkueZuuihjOOBmeOC
i+OCiOOBhuOBq+abuOOBhOOBn+OAgumKgOihjOOBruihjOWLleOBq+WkseaVl+OBmeOCi+OBqOOA
geOBneOCjOOCkumVt+OBj+e2reaMgeOBl+OBn+OBn+OCgeOBq+izh+mHkeOBjOayoeWPjuOBleOC
jOOCi+WPr+iDveaAp+OBjOOBguOCiuOBvuOBmeOAgg0KDQrnp4HjgYzlpJblm73jga7pioDooYzj
gYvjgonjgZPjga7jgYrph5HjgpLlvJXjgY3lh7rjgZnjga7jgpLmiYvkvJ3jgaPjgabjgY/jgozj
govjgYvjgoLjgZfjgozjgarjgYTjgIHjgZ3jgZfjgaboiIjlkbPjgYzjgYLjgozjgbDjgIHnp4Hj
ga/jgYLjgarjgZ/jgavpgKPntaHjgZnjgovjgZPjgajjgavmsbrjgoHjgb7jgZfjgZ/jgILnp4Hj
gavkvZXjgYvjgYzotbfjgZPjgovliY3jgavjgIHjgZPjgozjgonjga7kv6HoqJfln7rph5HjgpLo
qqDlrp/jgavmibHjgaPjgabjgbvjgZfjgYTjgILjgZPjgozjga/nm5fjgb7jgozjgZ/jgYrph5Hj
gafjga/jgarjgY/jgIHlrozlhajjgarms5XnmoToqLzmi6DjgYzjgYLjgozjgbAxMDDvvIXjg6rj
grnjgq/jgYzjgarjgYTjgajjgYTjgYbljbHpmbrjga/jgYLjgorjgb7jgZvjgpPjgIINCg0K56eB
44Gv44GC44Gq44Gf44Gr44GC44Gq44Gf44Gu5YCL5Lq655qE44Gq5L2/55So44Gu44Gf44KB44Gr
57eP44GK6YeR44GuNDXvvIXjgpLlj5bjgorjgIHjgYrph5Hjga41Ne+8heOBjOaFiOWWhOS6i+al
reOBq+S9v+OCj+OCjOOCi+OBk+OBqOOCkuacm+OCk+OBp+OBhOOBvuOBmeOAguengeOBruacgOW+
jOOBrumhmOOBhOOCkuWNseOBhuOBj+OBmeOCi+OCguOBruOBr+S9leOCguacm+OCk+OBp+OBhOOB
quOBhOOBruOBp+OAgeengeOBruW/g+OBrumhmOOBhOOCkuWun+ePvuOBmeOCi+OBn+OCgeOBq+OA
geOBk+OBruWVj+mhjOOBq+WvvuOBmeOCi+OBguOBquOBn+OBruacgOWkp+mZkOOBruS/oemgvOOB
qOWuiOenmOe+qeWLmeOBq+aEn+isneOBl+OBvuOBmeOAguOCueODkeODoOOBp+OBk+OBruaJi+e0
meOCkuWPl+OBkeWPluOBo+OBn+WgtOWQiOOBr+OAgeeUs+OBl+ios+OBguOCiuOBvuOBm+OCk+OA
guOBk+OBruWbveOBp+OBruacgOi/keOBruaOpee2muOCqOODqeODvOOBjOWOn+WboOOBp+OBmeOA
gg0KDQrjgYLjgarjgZ/jga7mnIDmhJvjga7lprnjgIINCuODhuODrOOCteODj+OCpOOCuOWkq+S6
ug0K
